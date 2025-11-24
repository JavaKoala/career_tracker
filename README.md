# Career Tracker

## Purpose

The purpose of this application is to track job applications from the initial application through acceptance. The application is developed to run in a home lab environment.

## Development Setup

### Install Mysql

https://dev.mysql.com/doc/refman/8.4/en/macos-installation.html

### Install Ruby version 3.4.7

I like rbenv ( https://github.com/rbenv/rbenv ), but rvm works too

### Clone the repository

```
git clone https://github.com/JavaKoala/career_tracker.git
```

### Application setup (in the folder with the application)

```
gem install bundler
bundle install
cp config/database.yml.sample config/database.yml
cp config/home_calendar.yml.sample config/home_calendar.yml
cp config/openai.yml.smaple config/openai.yml
cp config/influxdb.yml.sample influxdb.yml
```

- Update `config/database.yml` to the the local database credentials
- Update `config/openai.yml` to the the local ollama instance or disable
- Optionally update `config/home_calendar.yml` to enable the send to calendar feature
- Optionally update `config/influxdb.yml` to enable sending traces to InfluxDB

```
bin/rails db:create
bin/rails db:migrate
bin/rails s
```

Add a user through the Rails console

```
bin/rails c
User.create!(email_address: 'your_email@your-domain.com', password: 'your_secure_password!')
```

Go to http://localhost:3000 in a web browser to see the application

Optionally run the delayed jobs in another terminal if send to calendar or the LLM is enabled:

```
bundle exec rake jobs:work
```

## Docker Build and Run

1. Build image

```
docker build -t career_tracker .
```

2. Run image
```
docker run -it --rm --name career_tracker -p 3000:3000 \
  -e SECRET_KEY_BASE=<<Your Secret Key Base>> \
  -e DATABASE_URL="mysql2://<<Your User>>:<<Your Password>>@host.docker.internal/career_tracker_production" \
  -e RAILS_SERVE_STATIC_FILES=true \
  -e OPENAI_ENABLED=false \
  career_tracker
```
