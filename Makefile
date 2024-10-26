# Makefile commands for Laravel + Docker environment

# Start the entire environment
start:
	docker-compose up -d

# Stop the environment
stop:
	docker-compose down

# Build the environment
build:
	docker-compose build

# Run migrations
migrate:
	docker-compose exec app php artisan migrate

# Run unit tests
test:
	docker-compose exec app php artisan test

# Install composer dependencies
composer-install:
	docker-compose exec app composer install

# Seed the database
seed:
	docker-compose exec app php artisan db:seed

# Clear application cache
cache-clear:
	docker-compose exec app php artisan cache:clear

bash:
	docker-compose exec app /bin/sh