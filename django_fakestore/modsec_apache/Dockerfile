# Running Modsecurity in a Docker container;
# FROM ubuntu:latest
# ARG DEBIAN_FRONTEND=noninteractive

FROM httpd:2.4

# Run system update/upgrade
RUN apt update -y && apt upgrade -y

# Install Required Build Tools and Dependencies
RUN apt install -y g++ flex bison curl apache2-dev \
            doxygen libyajl-dev ssdeep liblua5.2-dev \
            libgeoip-dev libtool dh-autoreconf \
            libcurl4-gnutls-dev libxml2 libpcre3-dev \
            libxml2-dev git wget tar apache2

# Download LibModsecurity Source Code
RUN wget https://github.com/SpiderLabs/ModSecurity/releases/download/v3.0.4/modsecurity-v3.0.4.tar.gz

# Extract the ModSecurity source code.
RUN tar xzf modsecurity-v3.0.4.tar.gz && rm -rf modsecurity-v3.0.4.tar.gz

# Compile and Install LibModsecurity
RUN cd modsecurity-v3.0.4 && \
	./build.sh && ./configure && \
	make && make install

# Install ModSecurity-Apache Connector
RUN cd ~ && git clone https://github.com/SpiderLabs/ModSecurity-apache

RUN cd ~/ModSecurity-apache && \
	./autogen.sh && \
	./configure --with-libmodsecurity=/usr/local/modsecurity/ && \
	make && \
	make install

# Load the Apache ModSecurity Connector Module
RUN echo "LoadModule security3_module /usr/lib/apache2/modules/mod_security3.so" >> /etc/apache2/apache2.conf

# Configure ModSecurity
RUN mkdir /etc/apache2/modsecurity.d && \
	cp modsecurity-v3.0.4/modsecurity.conf-recommended /etc/apache2/modsecurity.d/modsecurity.conf && \
	cp modsecurity-v3.0.4/unicode.mapping /etc/apache2/modsecurity.d/ && \
	sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/apache2/modsecurity.d/modsecurity.conf
ADD modsec_rules.conf /etc/apache2/modsecurity.d/

# Install OWASP ModSecurity Core Rule Set (CRS) on Ubuntu
RUN git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /etc/apache2/modsecurity.d/owasp-crs && \
	cp /etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf.example /etc/apache2/modsecurity.d/owasp-crs/crs-setup.conf
# Activate ModSecurity
RUN mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.old
ADD 000-default.conf /etc/apache2/sites-available/

EXPOSE 8443

CMD apachectl -D FOREGROUND




# # Official Apache image
# FROM httpd:2.4
#
# # Install dependencies
# RUN apt-get update && apt-get install -y \
#     apache2 \
#     apache2-utils \
#     libapache2-mod-security2 \
#     modsecurity-crs \
#     curl \
#     vim \
#     openssl \
#     && apt-get clean
#
# # activate reverse proxy
# RUN a2enmod proxy \
#     && a2enmod proxy_http \
#     && a2enmod ssl \
#     && a2enmod headers \
#     && a2enmod negotiation
#
#
# # FROM httpd:2.4
# #
# # # Install modsecurity module and other important dependencies
# # RUN apt-get update && apt-get install -y \
# #     libapache2-mod-security2 \
# #     modsecurity-crs \
# #     curl \
# #     vim \
# #     apache2-utils \
# #     && a2enmod proxy \
# #     && a2enmod proxy_http \
# #     && a2enmod ssl \
# #     openssl && \
# #     apt-get clean
#
# # Generate temporary certificates
# RUN mkdir -p /usr/local/apache2/ssl
# RUN openssl req -x509 -nodes -out /usr/local/apache2/ssl/fakestore.crt \
#                             -keyout /usr/local/apache2/ssl/fakestore.key \
#                             -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=fakestore.fr/UID=fakestore"
# RUN ls -la /usr/local/apache2/ssl
#
#
# # Copy configuration files
# COPY ./conf/modsecurity.conf /etc/modsecurity/modsecurity.conf
# COPY ./conf/crs-setup.conf /etc/modsecurity/crs-setup.conf
# COPY ./conf/fakestore.conf /usr/local/apache2/conf/httpd.conf
# COPY ./conf/httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
#
#
# # activate CRS rules
# RUN sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf && \
#     a2enmod security2
#
# # Launch httpd
# CMD ["httpd-foreground"]
