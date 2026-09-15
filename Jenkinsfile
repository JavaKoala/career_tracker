pipeline {
  agent any
  stages {
    stage('checkout') {
      steps {
        deleteDir()
        checkout scmGit(
          branches: [[name: 'main']],
          userRemoteConfigs: [[url: 'https://github.com/JavaKoala/career_tracker']]
        )
      }
    }
    stage('build') {
      steps {
        sh """#!/bin/bash
          export HOME="/var/snap/jenkins/current"
          source /etc/profile
          rvm use 4.0.6
          bundle install
          cp config/database.yml.sample config/database.yml
          cp config/home_calendar.yml.sample config/home_calendar.yml
          cp config/openai.yml.sample config/openai.yml
          cp config/influxdb.yml.sample config/influxdb.yml
          sed -i 's/password:/password: password/' config/database.yml
          sed -i 's|socket: /tmp/mysql.sock|host: 127.0.0.1|' config/database.yml
          RAILS_ENV=test bin/rails db:reset
          NO_SANDBOX=true SKIP_FLAKY=true bin/ci
        """
      }
    }
  }
}
