FROM ruby:2.5
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN mkdir -p /home/app
RUN groupadd -r app &&\
useradd -r -g app -d /home/app -s /sbin/nologin -c "Docker image user" app

ENV HOME=/home/app
ENV APP_HOME=/home/app/my-project
RUN mkdir $APP_HOME
ADD Gemfile home/app/my-project/Gemfile
ADD Gemfile.lock home/app/my-project/Gemfile.lock
WORKDIR $APP_HOME

RUN gem install bundler -v 2.1.4
RUN bundle install

ADD . $APP_HOME
RUN chown -R app:app $APP_HOME
USER app
