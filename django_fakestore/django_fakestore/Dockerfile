
#install light python
FROM python:latest
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

#install POSTGRES client for database management
RUN apt-get update && apt-get install -y postgresql-client


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
