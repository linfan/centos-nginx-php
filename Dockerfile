FROM centos:centos7

ARG WEBROOT=/app/www

ADD yum.repos.d etc/

RUN yum update -y && \
    yum install -y epel-release && \
    yum install -y iproute python-setuptools wget \
                  hostname inotify-tools yum-utils which && \
    yum clean all && \
    rm -rf /tmp/yum* && \
    easy_install supervisor

RUN yum install -y nginx && \
    yum clean all && \
    rm -rf /tmp/yum* /etc/nginx/*.d /etc/nginx/*_params && \
    mkdir -p $WEBROOT && \
    chown -R nginx:nginx $WEBROOT

RUN rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum install -y \
      php70-php \
      php70-php-bcmath \
      php70-php-cli \
      php70-php-common \
      php70-php-devel \
      php70-php-fpm \
      php70-php-gd \
      php70-php-gmp \
      php70-php-intl \
      php70-php-json \
      php70-php-mbstring \
      php70-php-mcrypt \
      php70-php-mysqlnd \
      php70-php-opcache \
      php70-php-pdo \
      php70-php-pear \
      php70-php-process \
      php70-php-pspell \
      php70-php-xml \
      php70-php-pecl-imagick \
      php70-php-pecl-mysql \
      php70-php-pecl-uploadprogress \
      php70-php-pecl-uuid \
      php70-php-pecl-zip && \
    yum clean all && \
    rm -rf /tmp/yum* && \
    ln -sf /opt/remi/php70/enable /etc/profile.d/php70-paths.sh && \
    ln -sf /opt/remi/php70/root/usr/bin/{pear,pecl,phar,php,php-cgi,php-config,phpize} /usr/local/bin/. && \
    ln -sf /etc/opt/remi/php70/php.ini /etc/php.ini && \
    ln -sf /etc/opt/remi/php70/php.d /etc/php.d && \
    rm -rf /etc/php.d && \
    php --version && \
    echo 'PHP 7 installed.'

ADD fs /

EXPOSE 80 443

ENTRYPOINT ["/app/bootstrap.sh"]
