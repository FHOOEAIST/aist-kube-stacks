FROM httpd:latest

# These variables are inherited from the httpd:alpine image:
# ENV HTTPD_PREFIX /usr/local/apache2
# WORKDIR "$HTTPD_PREFIX"

# Copy in our configuration files.
COPY conf/ conf/

RUN set -ex; \
    # Create jovyan user
    useradd -G users,www-data jovyan; \
    # Create empty default DocumentRoot.
    mkdir -p "/var/www/html"; \
    # Create directories for Dav data and lock database.
    mkdir -p "/var/lib/dav/data"; \
    touch "/var/lib/dav/DavLock"; \
    chown -R jovyan:users "/var/lib/dav"; \
    \
    # Enable DAV modules.
    for i in dav dav_fs; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Make sure authentication modules are enabled.
    for i in authn_core authn_file authz_core authz_user auth_basic auth_digest; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Make sure other modules are enabled.
    for i in alias headers mime setenvif; do \
        sed -i -e "/^#LoadModule ${i}_module.*/s/^#//" "conf/httpd.conf"; \
    done; \
    \
    # Run httpd as "jovyan" (instead of "daemon" and "www-data").
    sed -i -e "s|^User .*|User jovyan|" "conf/httpd.conf"; \
    sed -i -e "s|^Group .*|Group users|" "conf/httpd.conf"; \
    \
    # Include enabled configs and sites.
    printf '%s\n' "Include conf/conf-enabled/*.conf" \
        >> "conf/httpd.conf"; \
    printf '%s\n' "Include conf/sites-enabled/*.conf" \
        >> "conf/httpd.conf"; \
    \
    # Enable dav and default site.
    mkdir -p "conf/conf-enabled"; \
    mkdir -p "conf/sites-enabled"; \
    ln -s ../conf-available/dav.conf "conf/conf-enabled"; \
    ln -s ../sites-available/default.conf "conf/sites-enabled"

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN set -ex; \
    chown -R jovyan:users "/var/www/html"; \
    chown -R jovyan:users "$HTTPD_PREFIX"; \
    chown -R jovyan:users "/usr/local/bin/docker-entrypoint.sh"; \
    touch "/user.passwd"; \
    chown -R jovyan:users "/user.passwd"

EXPOSE 80/tcp 443/tcp
ENTRYPOINT [ "docker-entrypoint.sh" ]
CMD [ "httpd-foreground" ]
