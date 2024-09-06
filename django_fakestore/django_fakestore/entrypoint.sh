#!/bin/bash


echo "Check project exitence. If not create. If exists update database and collect static files"
if [ ! -f "manage.py" ]; then
  echo "Creating project..."
  django-admin startproject fakestore .
  sleep 3 
  python manage.py startapp store
else
  echo "Making migrations for store application..."
  python manage.py makemigrations store
  python manage.py migrate
  # python manage.py collectstatic --noinput
fi

echo "Waiting for apps ..."
sleep 5

echo "Launch WSGI server ..."
# daphne -b 0.0.0.0 -p 8002 pythpong.asgi:application
exec python -u manage.py runserver 0.0.0.0:8001
