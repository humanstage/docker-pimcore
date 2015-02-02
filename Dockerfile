FROM google/debian:wheezy
MAINTAINER pimcore GmbH <info@pimcore.com>

RUN apt-get update && \
 DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && \
 DEBIAN_FRONTEND=noninteractive apt-get -y install wget sudo 

ADD sources.list /sources.list
RUN cat sources.list >> /etc/apt/sources.list 

RUN wget -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add - 

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
 php5-fpm php5-cli php5-curl php5-dev php5-gd php5-imagick php5-imap \
 php5-intl php5-mcrypt php5-memcache php5-mysql php5-sqlite php5-redis \
 bzip2 unzip libxrender1 libfontconfig1 imagemagick \
 build-essential libssl-dev lynx autoconf libmagickwand-dev \
 pngnq pngcrush xvfb cabextract libfcgi0ldbl poppler-utils

RUN apt-get -y -t wheezy-backports install libreoffice python-uno libreoffice-math

RUN apt-get -y install apache2-mpm-worker libapache2-mod-fastcgi
 
# Override default apache conf
ADD vhost.conf /etc/apache2/sites-enabled/default

RUN rm -r /etc/php5/cli/php.ini && ln -s /etc/php5/fpm/php.ini /etc/php5/cli/php.ini
RUN mv /etc/php5/fpm/pool.d/www.conf /etc/php5/fpm/pool.d/www.conf.dist

# Enable apache rewrite module
RUN a2enmod rewrite

RUN wget https://www.pimcore.org/download/pimcore-latest.zip -O /var/www/pimcore.zip 
RUN cd /var/www && unzip pimcore.zip && rm pimcore.zip 

EXPOSE 80
#CMD ["/run.sh"]