FROM python:latest

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

WORKDIR /app

COPY requirements.txt /app/
COPY init_mysite.sh /app/

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x /app/init_mysite.sh

ENTRYPOINT ["/app/init_mysite.sh"]

#CMD ["gunicorn", "--bind", "0.0.0.8000", "mysite.wsgi:application"]
