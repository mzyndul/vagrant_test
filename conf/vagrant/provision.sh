#!/usr/bin/env bash

echo "Installing system packages"
apt-get update -y
apt-get install -y build-essential python-pip python-dev swig mc git

# Dependencies for virtualenv
apt-get install -y libjpeg8 libjpeg8-dev libtiff-dev zlib1g-dev libfreetype6-dev liblcms2-dev libxml2-dev libxslt1-dev libssl-dev

echo "Setting up pip and virtualenv"
pip install virtualenv
pip install virtualenvwrapper

echo "Creating virtualenv and configuring app"
su - vagrant -c "mkdir -p /home/vagrant/envs"
su - vagrant -c "export WORKON_HOME=~/envs && \
source /usr/local/bin/virtualenvwrapper.sh && \
mkvirtualenv vagrant && \
pip install -r /vagrant/requirements/dev.txt && \
cd /vagrant/project && \
python manage.py syncdb --noinput && \
python manage.py migrate"

cp -p /vagrant/conf/templates/.bashrc /home/vagrant/.bashrc