dev:
	docker-compose up -d --build

up:
	docker-compose up --build

stop:
	docker-compose down --remove-orphans

restart: stop dev
