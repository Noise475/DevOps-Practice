FROM nginx:1.19.1-alpine

# Create log/cache directory and set permissions
RUN mkdir -p /var/log/nginx /var/cache/nginx /var/run/nginx   && \
    chmod 750 /var/log/nginx /var/cache/nginx /var/run/nginx && \
    chown nginx:nginx /var/log/nginx /var/cache/nginx /var/run/nginx

# Set permissions for the nginx configuration file
RUN chmod 640 /etc/nginx/nginx.conf

# Copy custom configuration
COPY --chown=nginx:nginx . .

# Create a non-root user (Nginx uses the 'nginx' user by default, but if you make changes, switch accordingly)
USER nginx

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
