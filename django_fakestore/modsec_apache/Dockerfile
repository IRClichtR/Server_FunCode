# Official Apache image
FROM httpd:2.4

# Install modsecurity module and other important dependencies
RUN apt-get update && apt-get install -y \
    libapache2-mod-security2 \
    modsecurity-crs \
    curl \
    vim \
    openssl && \
    apt-get clean

# Generate temporary certificates
RUN mkdir -p /etc/ssl
RUN openssl req -x509 -nodes -out /etc/ssl/fakestore.crt \
    -keyout /etc/ssl/fakestore.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=fakestore.fr/UID=fakestore"

# Copy configuration files
COPY ./conf/modsecurity.conf /etc/modsecurity/modsecurity.conf
COPY ./conf/crs-setup.conf /etc/modsecurity/crs-setup.conf
COPY ./conf/fakestore.conf /usr/local/apache2/conf/httpd.conf

