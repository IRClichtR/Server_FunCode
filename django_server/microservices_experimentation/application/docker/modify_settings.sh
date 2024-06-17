#!/bin/bash 

# Provisoire
SERVICE_NAME="user_management"
SERVICE_PORT="8001"

echo "Edit settings.py"

# check if settings.py is in the directory
settings="$SERVICE_NAME/settings.py"
if [ ! -f $settings ]; then
  echo "no settings.py file in directory. Script not applicable!"
  exit 0
fi 

# add new imports to file

imports_line="from pathlib import Path"

new_imports=$(cat <<EOF 
import os
from dotenv import load_dotenv
from django.conf import settings

# Use .env args from docker
load_dotenv()
EOF
)

added_apps=$(cat <<EOF
  'rest_framework',
  '$SERVICE_NAME',
EOF
)

# Service variables

new_variables=$(cat <<EOF
# define service URL for internal communication
SERVICE_URL = os.getenv('SERVICE_URL', 'http://$SERVICE_NAME:$SERVICE_PORT')

# Static files management
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [os.path.join(BASE_DIR, "$SERVICE_NAME/static")]
EOF
)

# Data base configuration

database_config=$(cat <<EOF
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': os.getenv('SERVICE_DB'),
    'USER': os.getenv('SERVICE_DBUSER'),
    'PASSWORD': os.getenv('SERVICE_DBPASS'),
    'HOST': os.getenv('SERVICE_DBHOST'),
    'PORT': os.getenv('SERVICE_DBPORT'),
  }
}
EOF
)


# REST framework basic configuration
rest_config=$(cat <<EOF
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': [
        'rest_framework.authentication.SessionAuthentication',
        'rest_framework.authentication.BasicAuthentication',
    ],
    'DEFAULT_PERMISSION_CLASSES': [
        'rest_framework.permissions.AllowAny',
    ],
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 10,
}
EOF
)

# Create tmp file

tmp=$(mktemp)

# set flag to find database block
in_db_block=false

# Read file loop
while IFS= read -r line; do 
  
  if [[ "$line" == "from pathlib import Path" ]]; then
    echo "$line" >> "$tmp"
    echo "$new_imports" >> "$tmp"
    echo "$new_variables" >> "$tmp"    
  elif echo "$line" | grep -q "SECRET_KEY ="; then
    echo "SECRET_KEY = os.getenv('SERVICE_DJANGO_SECRET_KEY')" >> "$tmp"
  elif echo "$line" | grep -q "ALLOWED_HOSTS ="; then
    echo "ALLOWED_HOSTS = os.getenv('SERVICE_ALLOWED_HOSTS').split(',')" >> "$tmp"
  elif echo "$line" | grep -q "STATIC_URL ="; then
    continue
  elif [[ "$line" == "DATABASES = {" ]]; then
    in_db_block=true
    echo "$database_config" >> "$tmp"
  elif [[ $in_db_block == true ]]; then
    # echo " Here flage is true == $line"
    if [[ "$line" == "}" ]]; then
      in_db_block=false
    fi 
  elif [[ "$line" == "INSTALLED_APPS = [" ]]; then
    echo "$line" >> "$tmp"
    echo "$added_apps" >> "$tmp"
  else 
    echo "$line" >> "$tmp"
  fi
  
done < "$settings"

echo "$rest_config" >> "$tmp"
mv "$tmp" "$settings"

echo "-- settings.py edit DONE --"
