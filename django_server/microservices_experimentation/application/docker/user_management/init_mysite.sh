#!/bin/sh

echo "Hello from Django init script!"

if [ ! -f "manage.py" ]; then
  echo "create mysite initial configuration..."
  django-admin startproject $SERVICE_NAME .
  sleep 3

  # Modify settings.py file
  chmod +x ./modify_settings.sh
  source modify_settings.sh
fi

# Link database with service
echo "update infos..."
python manage.py migrate
python manage.py collectstatic --noinput

#start service
exec "$@"
