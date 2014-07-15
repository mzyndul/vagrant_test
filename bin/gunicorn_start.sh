#!/bin/bash

NAME="hello_app"                                  # Name of the application
DJANGODIR=/vagrant/project                        # Django project directory
SOCKFILE=/vagrant/bin/gunicorn.sock               # we will communicte using this unix socket
USER=vagrant                                      # the user to run as
GROUP=vagrant                                     # the group to run as
NUM_WORKERS=3                                     # how many worker processes should Gunicorn spawn
DJANGO_SETTINGS_MODULE=settings.dev               # which settings file should Django use
DJANGO_WSGI_MODULE=michael.wsgi                   # WSGI module name

echo "Starting $NAME as `whoami`"

# Activate the virtual environment
cd $DJANGODIR
workon vagrant
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH

# Create the run directory if it doesn't exist
RUNDIR=$(dirname $SOCKFILE)
test -d $RUNDIR || mkdir -p $RUNDIR

# Start your Django Gunicorn
# Programs meant to be run under supervisor should not daemonize themselves (do not use --daemon)
exec /vagrant/bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
  --name $NAME \
  --workers $NUM_WORKERS \
  --user=$USER --group=$GROUP \
  --log-level=debug \
  --bind=unix:$SOCKFILE