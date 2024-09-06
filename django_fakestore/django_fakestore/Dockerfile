
#install light python
FROM python:latest
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

#install POSTGRES client for database management
RUN apt-get update && apt-get install -y postgresql-client

#install openssl to create and manage certificates
# RUN apt-get install openssl

# RUN mkdir -p /etc/ssl/certs 
# WORKDIR /etc/ssl/certs
# RUN openssl genpkey -algorithm RSA -out private_key.pem 
# RUN openssl req -new -key private_key.pem -out django_cert.pem -subj "/CN=localhost"
# RUN openssl x509 -req -days 365 -in django_cert.pem -signkey private_key.pem -out django_selfsigned_cert.pem

# go to /app dir and copy all recessary file into dir
WORKDIR /app
COPY . /app 

# make entrypoint executable and install python dependancies
RUN chmod +x ./entrypoint.sh
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

#check directory for debug
RUN ls -la /app 

#launch application
ENTRYPOINT ["/bin/bash", "-c", "./entrypoint.sh"]
