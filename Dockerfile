FROM node:22-alpine AS base
RUN apk add --no-cache libc6-compat openssl
RUN corepack enable && corepack prepare pnpm@latest --activate

FROM base AS deps
WORKDIR /app
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY prisma/schema.prisma prisma/schema.prisma
COPY prisma.config.ts ./
# dummy environment variable required for `prisma generate` postinstall script
ENV POSTGRES_PRISMA_URL="postgres://postgres:postgres@localhost:5432/currencies?schema=public"
RUN pnpm install --frozen-lockfile

FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
ENV NEXT_TELEMETRY_DISABLED=1
# copy prisma-generated files to the container
# option 1: copy generated files from deps stage to builder stage
# COPY --from=deps /app/prisma/generated ./prisma/generated
# option 2: generate prisma-generated files in builder stage
ENV POSTGRES_PRISMA_URL="postgres://postgres:postgres@localhost:5432/currencies?schema=public"
RUN pnpm exec prisma generate
# end of prisma generate
RUN pnpm build

FROM base AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
RUN addgroup --system --gid 1001 nodejs && \
    adduser --system --uid 1001 nextjs
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static
COPY --from=builder /app/prisma ./prisma
USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
