DOCKER_COMPOSE = docker compose -f docker-compose.yml
BUNDLE_FLAGS=

ifdef DEPLOYMENT
  BUNDLE_FLAGS = --without test development
endif

DOCKER_COMPOSE += -f docker-compose.development.yml
DOCKER_COMPOSE_NO2FA = $(DOCKER_COMPOSE) -f docker-compose-no2fa.yml


DOCKER_BUILD_CMD = BUNDLE_INSTALL_FLAGS="$(BUNDLE_FLAGS)" $(DOCKER_COMPOSE) build

build:
	docker build . -t govwifi_two_factor_auth

lint: build
	docker run -t govwifi_two_factor_auth bundle exec rubocop .

test: build
	docker run -t govwifi_two_factor_auth

shell: build
	docker run -it govwifi_two_factor_auth /bin/sh
