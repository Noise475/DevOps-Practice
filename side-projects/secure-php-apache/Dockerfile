# Use an official PHP runtime as a parent image
FROM php:8.0-apache 

# Create non-root user
RUN groupadd -r mygroup && useradd -r -g mygroup -u 1001 myuser

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Use the default production configuration
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install necessary packages and extensions
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y libapache2-mod-security2 && \
    docker-php-ext-install pdo_mysql

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Enable ModSecurity
RUN a2enmod security2

# Enable headers
RUN a2enmod headers

# Modify permissions to increase security
RUN chown -R myuser:mygroup /app && \
    chmod -R 755 /app

# Set ownership and permissions for Apache configuration files
RUN chown myuser:mygroup /etc/apache2/sites-available/000-default.conf && \
    chmod 544 /etc/apache2/sites-available/000-default.conf

# Create the directory and set permissions
RUN mkdir -p /var/log/modsecurity && \
    mkdir -p /etc/modsecurity

# Copy Apache configuration file
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Copy ModSecurity configuration files
COPY .docker/modsecurity.conf /etc/modsecurity/modsecurity.conf
COPY .docker/unicode.mapping /etc/modsecurity/unicode.mapping

# Set ownership for ModSecurity configuration files
RUN chown myuser:mygroup /etc/modsecurity/modsecurity.conf && \
    chown myuser:mygroup /etc/modsecurity/unicode.mapping && \
    chown myuser:mygroup /var/log/modsecurity

# Set permissions ModSecurity configuration files
RUN chmod 544 -R /etc/modsecurity/modsecurity.conf && \
    chmod 544 -R /etc/modsecurity/unicode.mapping && \
    chmod 755 -R /var/log/modsecurity

# Use non-root user
USER myuser

# Expose port 80
EXPOSE 80

# Define the command to run the app using CMD which keeps the container running.
CMD ["apachectl", "-D", "FOREGROUND"]
