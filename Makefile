.PHONY: up down migrate-dev migrate-prod reset-db start

up: 
	docker compose up -d

down:
	docker compose down -v

# Generate new migration files for changes to schema.prisma and apply them to the database.
migrate-dev:
	pnpm db:migrate
	pnpm exec prisma generate

# ⚠️ Reset database and apply all migrations.
reset-db:
	pnpm exec prisma migrate reset

# Only apply migrations to database.
migrate-prod:
	docker compose up -d postgres
	pnpm exec prisma migrate deploy

start:
	make migrate-prod
	make up
