#!/bin/sh

set -e		# If any command fails, the script exits immediately. This prevents starting Gunicorn with a broken application.

echo "Running Django system checks..."
python manage.py check		# Verifies the Django project configuration before serving requests.

echo "Collecting static files..."
python manage.py collectstatic --noinput	# Populates the shared static_volume every time the container starts. This solves the empty-volume issue on a fresh deployment.

echo "Starting Gunicorn..."

exec gunicorn -c deployment/gunicorn.conf.py config.wsgi:application 	# Replaces the shell with Gunicorn so Gunicorn becomes PID 1 and receives signals directly from Docker.
