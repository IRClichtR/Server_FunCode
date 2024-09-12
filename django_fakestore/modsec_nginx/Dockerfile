#build from nginx official image
FROM nginx:latest

# Install necessary apps tto run modsec and nginx-modsec
RUN apt-get update && \ 
    apt-get install -y  libmodsecurity-dev \
                        libmodsecurity3 \
                        git build-essential \
                        libpcre3 \
                        libpcre3-dev \
                        libxml2 \
                        libxml2-dev \
                        zlib1g \
                        zlib1g-dev \
                        libssl-dev \
                        openssl

# Generate temporary certificates
RUN mkdir -p /etc/nginx/ssl
RUN     openssl req -x509 -nodes -out /etc/nginx/ssl/fakestore.crt \
        -keyout /etc/nginx/ssl/fakestore.key -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=fakestore.fr/UID=fakestore"


# clone Modsecurity repository (only main branch)
RUN git clone https://github.com/owasp-modsecurity/ModSecurity.git /opt/ModSecurity && \
    cd /opt/ModSecurity && \
    ./build.sh && \
    ./configure && \
    make && \
    make install

# clone modesecurity-nginx module repository
RUN git clone https://github.com/owasp-modsecurity/ModSecurity-nginx.git /opt/ModSecurity-nginx 

RUN mkdir -p /etc/nginx/modsec 
COPY ./conf/modsecurity.conf /etc/nginx/modsec/modsecurity.conf 
COPY ./conf/main.conf /etc/nginx/modsec/main.conf
COPY ./conf/modsecurity.conf /opt/ModSecurity/modsecurity.conf 
COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./conf/default /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]
