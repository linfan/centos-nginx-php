# centos-nginx-php
A minimum CentOS based image with nginx and php 7 installed

## Built it

docker build -t centos-nginx-php .

## Run it
docker run -d --name=nginx-php -p 80:80 centos-nginx-php
