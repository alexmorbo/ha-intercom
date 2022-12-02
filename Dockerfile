ARG BUILD_FROM=ghcr.io/hassio-addons/base:12.2.7
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
# hadolint ignore=DL3003
RUN \
    apk add --no-cache \
        nginx \
        php81-curl \
        php81-fpm \
        php81-iconv \
        php81-mbstring \
        php81-opcache \
        php81-session \
        php81-zip \
        php81 \
    \
    && apk add --no-cache --virtual .build-dependencies \
        composer \
        git \
        nodejs=16.17.1-r0 \
        npm=8.10.0-r0 \
    \
    && git clone --branch "dev" --depth=1 \
        "https://github.com/alexmorbo/intercom-admin.git" /var/www/ha-intercom \
    \
    && cd /var/www/ha-intercom/ha-intercom \
    && composer install --no-dev \
    \
    && apk del --no-cache --purge .build-dependencies \
    \
    && rm -f -r \
        /root/.composer \
        /root/.npm \
        /var/www/ha-intercom/.git \
    \

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Alex Morbo <alex@morbo.ru>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}