#!/bin/bash

set -e

check_docker_compose() {
  if command -v docker-compose &> /dev/null
  then
      echo "docker-compose"
      return
  fi
  if docker compose --help &> /dev/null
  then
      echo "docker compose"
      return
  fi

  echo "docker-compose is not installed or not in PATH. Please follow the steps from the official guide: https://docs.docker.com/engine/install/" > /dev/stderr
  exit 1
}

DOCKER_COMPOSE_COMMAND=$(check_docker_compose)

echo "Stopping and removing NetBird containers..."
$DOCKER_COMPOSE_COMMAND down -v

echo "Stopping and removing Traefik stack..."
cd /traefik-stack
$DOCKER_COMPOSE_COMMAND down
cd - > /dev/null

echo "Removing NetBird configuration files..."
rm -rf machinekey/ .env *.env *.yml *.json *.conf

echo "Uninstallation complete!"
