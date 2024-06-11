#!/bin/sh

echo "Hello from Django init script!"

if [ ! -f "manage.py" ]; then
  echo "create mysite initial configuration..."
  django-admin startproject mysite .


  # Add databas to setings.py 
else
  echo "update infos..."
  python manage.py migrate
  python manage.py collectstatic --noinput
   exec "$@"
fi
