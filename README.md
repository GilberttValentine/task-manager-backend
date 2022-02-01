# Task manager - Backend

System
* Ruby version - 3.0.0
* Rails version - 7.0.1

Dependencies
* jwt
* bycript 3.1.7

Testing Dependencies
* rspec-rails
* factory_bot_rails
* shoulda-matchers 3.1
* faker
* database_cleaner

## Run migrations
```rails db:migrate:reset```
```rails db:test:prepare```

## Commands for testing:

> Run authorization request tests

```bundle exec rspec spec/auth -fd```

> Run endpoint tests

```bundle exec rspec```
