FROM nginx:latest


# Install OpenSSL
RUN apt-get install -y openssl && mkdir -p /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/cert.pem -keyout /etc/nginx/ssl/key.pem -subj "/CN=mysite.com"

COPY  nginx.conf /etc/nginx/nginx.conf
RUN chmod 644 /etc/nginx/nginx.conf

EXPOSE 80
EXPOSE 443
