#!/usr/bin/env bash
set -euo pipefail

${TASKS_DIR}/start_service_if_not_running.sh ${SERVICE_PHP_XDEBUG}

if [[ "${XDEBUG_HOST:-}" == "" ]]; then
    source ${TASKS_DIR}/set_xdebug_host_property.sh
fi

if [[ "${XDEBUG_HOST:-}" != "" ]]; then
    ${COMMANDS_DIR}/exec-debug.sh sed -i "s/xdebug\.client_host\=.*/xdebug\.client_host\=${XDEBUG_HOST}/g" /usr/local/etc/php/conf.d/xdebug.ini
fi

${COMMANDS_DIR}/exec-debug.sh sed -i -e 's/^\;zend_extension/zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

${DOCKER_COMPOSE} restart ${SERVICE_PHP_XDEBUG}

printf "${YELLOW}xdebug configuration: ${COLOR_RESET}\n"
printf "${YELLOW}--------------------------------${COLOR_RESET}\n"
${COMMANDS_DIR}/exec-debug.sh php -i | grep -e "xdebug.idekey" -e "xdebug.client_host" -e "xdebug.client_port" | cut -d= -f1-2
printf "${YELLOW}--------------------------------${COLOR_RESET}\n"
