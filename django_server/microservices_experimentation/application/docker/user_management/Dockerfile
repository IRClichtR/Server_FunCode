FROM python:latest

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONBUFFERED 1

ARG SERVICE_NAME

WORKDIR /app

COPY requirements.txt /app/
COPY init_service.sh /app/
COPY modify_settings.sh /app/ 

RUN pip install --no-cache-dir -r requirements.txt

RUN chmod +x /app/init_service.sh
RUN chmod +x /app/modify_settings.sh

ENTRYPOINT ["/app/init_service.sh"]

CMD ["gunicorn", "--bind", "0.0.0.0.8000", "$SERVICE_NAME.wsgi:application"]
