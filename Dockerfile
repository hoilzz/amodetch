# Dockerfile
FROM seapy/rails-nginx-unicorn-pro:v1.0-ruby2.2.0-nginx1.6.0
MAINTAINER seapy(iamseapy@gmail.com)

# Add here your preinstall lib(e.g. imagemagick, mysql lib, pg lib, ssh config)
RUN apt-get update
RUN apt-get install -qq -y mysql-server mysql-client libmysqlclient-dev


#(required) Install Rails App
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --without development test
RUN bundle list
#RUN rails generate rollbar da5af88fecdb42ac85994bbebb9aadc7
ADD . /app



#(required) nginx port number
EXPOSE 80
