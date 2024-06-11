#!/bin/bash 

# Provisoire
USMAN_SERVICE_NAME="user_management"

echo "Edit settings.py"


settings="settings.py"
if [ ! -f $settings ]; then
  echo "no settings.py file in directory. Script none applicable!"
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
  '$USMAN_SERVICE_NAME',
EOF
)

# Service variables

new_variables=$(cat <<EOF
# define service URL for internal communication
USER_SERVICE_URL = os.getenv('USER_SERVICE_URL', 'http://$USMAN_SERVICE_NAME:8000')
ALLOWED_HOSTS = os.getenv('USMAN_ALLOWED_HOSTS').split(',')

# Static files management
STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'staticfiles')
STATICFILES_DIRS = [os.path.join(BASE_DIR, "$USMAN_SERVICE_NAME/static")]
EOF
)

# Data base configuration

database_config=$(cat <<EOF
DATABASES = {
  'default': {
    'ENGINE': 'django.db.backends.postgresql',
    'NAME': os.getenv('USMAN_DB'),
    'USER': os.getenv('USMAN_USER'),
    'PASSWORD': os.getenv('USMAN_PASS'),
    'HOST': os.getenv('USMAN_HOST'),
    'PORT': os.getenv('USMAN_PORT'),
  }
}
EOF
)

# Create tmp file

tmp=$(mktemp)

# set flag to find database block
in_db_block=false

# Read file loop
while IFS= read -r line; do 

  if [[ "$line" == "$imports_line" ]]; then

    echo "$line" >> "$tmp"
    IFS= read -r next_line
    if [[ -z "$next_line" ]]; then
      echo "$new_imports" >> "$tmp"
      echo "$new_variables" >> "$tmp"    
    fi 
    echo "$next_line" >> "$tmp"

  elif [[ "$line" == "DATABASES = {" ]]; then
    in_db_block=true
    echo "$database_config" >> "$tmp"

  elif [[ $in_db_block ]]; then
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

mv "$tmp" "$settings"

echo "-- settings.py edit DONE --"
