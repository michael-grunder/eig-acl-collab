FROM centos:latest

COPY .vimrc redis.conf users.acl test.php vg.supp /root/

RUN yum -y update && \
    yum -y install centos-release-scl && yum -y install devtoolset-8
RUN yum -y install httpd make wget git gdb valgrind vim libxml2-devel zlib-devel curl autoconf autotools-dev ctags
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install yum-utils && yum-config-manager --enable remi-php73 && \
    yum -y install php73 php73-php-devel

# PhpRedis && Redis 6.0.5
RUN source scl_source enable php73 && source scl_source enable devtoolset-8 && \
    cd /root/ && git clone https://www.github.com/phpredis/phpredis && cd phpredis && git checkout acls && \
        phpize && ./configure && make && make install && \
    cd /root/ && git clone https://www.github.com/antirez/redis && cd redis && git checkout 6.0.5 && \
        make && make install

# All the other php extensions
RUN yum -y install \
    php73 php73-php-pecl php73-php-bcmath php73-php-cli php73-php-common \
    php73-php-dbg php73-php-fpm php73-php-gd php73-php-gmp php73-php-intl \
    php73-php-json php73-php-mbstring php73-php-mysqlnd php73-php-odbc \
    php73-php-opcache php73-php-pdo php73-php-pecl-igbinary php73-php-pecl-imagick \
    php73-php-pecl-msgpack php73-php-pecl-zip php73-php-pgsql php73-php-phpiredis \
    php73-php-process php73-php-pspell php73-php-soap php73-php-xml php73-php-xmlrpc \
    php73-runtime

RUN echo "alias vi=vim" >> /root/.bashrc && \
    echo "source scl_source enable devtoolset-8" >> /root/.bashrc && \
    echo "source scl_source enable php73" >> /root/.bashrc && \
    echo "extension=redis.so" > /etc/opt/remi/php73/php.d/20-redis.ini

CMD ["redis-server", "/root/redis.conf"]
