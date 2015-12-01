# Ruby on Rails Tutorial

[![Build Status](https://travis-ci.org/zapidan/twitter-rails.svg?branch=master)](https://travis-ci.org/zapidan/twitter-rails)

This is the sample application for the
[*Ruby on Rails Tutorial:
Learn Web Development with Rails*](http://www.railstutorial.org/)
by [Michael Hartl](http://www.michaelhartl.com/).

It has been deployed to heroku (https://twitter-rails.herokuapp.com)

Instead of using a gem such as devise for authentication, it focuses on building a whole authentication system with remember me, activation, reset tokens and other functionalities.

## Development Use:

Clone repo:

  ```bash
  $ git clone git@github.com:zapidan/twitter-rails.git
  ```

Install gems:

  ```ruby
  bundle install --without production
  ```

Install figaro (needed to create ENV variables to create the admin user from the seeds.rb):

  ```bash
  $ figaro install
  ```

Create ENV variables in config/application.yml

  ```yml
  gmail_username: "example@gmail.com"
  gmail_password: "password"
  ```
Make sure you allow less secure apps on gmail (https://myaccount.google.com/security). Remember to turn it back off once you have finished testing.

Run db migrations and seeding of some fake users:

  ```ruby
  rake db:setup
  ```

Start server and enjoy!

  ```ruby
  rails server
  ```
