# syntax=docker/dockerfile:1

ARG PHP_VERSION="8.3"
FROM php:${PHP_VERSION}-apache

# Instalar dependencias necesarias y preparar SSH
RUN apt-get update && apt-get install -y \
    libldap2-dev \
    libsasl2-dev \
    git \
    openssh-client \
 && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
 && docker-php-ext-install ldap \
 && a2enmod rewrite \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /root/.ssh && chmod 700 /root/.ssh

# Establecer el directorio de trabajo
WORKDIR /var/www/html

# Definir variables de entorno para evitar fallos si no están definidas
ENV RSA_KEY=""
ENV GIT_URL=""

# Script de arranque: configura SSH, clona el repo y arranca Apache
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
CMD ["apache2-foreground"]
