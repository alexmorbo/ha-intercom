#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: HA Intercom
# Configures HA Intercom
# ==============================================================================

# Ensure persistant storage exists
if ! bashio::fs.directory_exists "/data/ha-intercom"; then
    bashio::log.debug 'Data directory not initialized, doing that now...'

    # Setup structure
    mkdir -p /data/ha-intercom
    cp -R /var/www/app/data /data/ha-intercom

    # Ensure file permissions
    chown -R nginx:nginx /data/ha-intercom
    find /data/ha-intercom -not -perm 0644 -type f -exec chmod 0644 {} \;
    find /data/ha-intercom -not -perm 0755 -type d -exec chmod 0755 {} \;
fi

bashio::log.debug 'Symlinking data directory to persistent storage location...'
rm -f -r /var/www/app/data
ln -s /data/ha-intercom /var/www/app/data