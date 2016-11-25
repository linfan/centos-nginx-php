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
      php70-php-cli \
      php70-php-common \
      php70-php-devel \
      php70-php-fpm && \
    yum clean all && \
    rm -rf /tmp/yum* && \
    ln -sf /opt/remi/php70/enable /etc/profile.d/php70-paths.sh && \
    ln -sf /opt/remi/php70/root/usr/bin/* /usr/local/bin/. && \
    ln -sf /etc/opt/remi/php70/php.ini /etc/php.ini && \
    ln -sf /etc/opt/remi/php70/php.d /etc/php.d && \
    rm -rf /etc/php.d && \
    php --version && \
    echo 'PHP 7 installed.'

ADD fs /

EXPOSE 80 443

ENTRYPOINT ["/app/bootstrap.sh"]
