# README

## Purpose

Develop concepts that define cloud computing by adopting software construction techniques as a service, from development to deployment in a production environment.

## Scope

Coupons is based on the creation, management and traceability of promotional coupons and discounts.
They can be managed from the same place. That is, given a coupon that a company is offering, the system must validate if the coupon is valid and if it also complies with the rules to be applied.

## Ruby & Rails version

- Ruby: 2.6.3p62

- Rails: 6.0.0

## External system dependencies

- rubocop-rails: Focused on enforcing Rails best practices and coding conventions.

- dotenv-rails: Use for management of environment variables.

- annotate: Add a comment summarizing the current schema.

- bcrypt: Use for password management.

- pg: Pg is the Ruby interface to the PostgreSQL RDBMS.

- acts_as_tenant: A Rails plugin to add soft delete.

- bootstrap: Apply styles on views easier.

- jquery-rails: Apply jquery in the views.

- acts_as_paranoid: Manage logic deletion.

- dentaku: Dentaku is a parser and evaluator for a mathematical and logical formula language that allows run-time binding of values to variables referenced in the formulas. It is intended to safely evaluate untrusted expressions without opening security holes.

- faker: Generates fake data.

- has_scope: Has scope allows you to map incoming controller parameters to named scopes in your resources.

- image_processing: Provides higher-level image processing helpers that are commonly needed when handling image uploads.

- health_check: Quickly check that rails is up and running and that it has access to correctly configured resources (database, email gateway)

- logglier: Use for logging the syslog of the system.

- puma: Puma processes requests using a C-optimized Ragel extension (inherited from Mongrel) that provides fast, accurate HTTP 1.1 protocol parsing in a portable way. Puma then serves the request using a thread pool. Each request is served in a separate thread, so truly concurrent Ruby implementations (JRuby, Rubinius) will use all available CPU cores.

- sass-rails: Use SCSS for stylesheets

- webpacker: Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker

- turbolinks: Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks

- jbuilder: Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

- bootsnap: Reduces boot times through caching; required in config/boot.rb

- byebug: Call 'byebug' anywhere in the code to stop execution and get a debugger console

- listen: The Listen gem listens to file modifications and notifies you about the changes.

- web-console: Access an interactive console on exception pages or by calling 'console' anywhere in the code.

- spring: Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

- spring-watcher-listen: Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring

- capybara: Capybara helps you test web applications by simulating how a real user would interact with your app.

- selenium-webdriver: WebDriver is a tool for writing automated tests of websites.

- webdrivers: Run Selenium tests more easily with automatic installation and updates for all supported webdrivers.

## Development instructions

- Download repository

```bash
git clone https://github.com/ArqSoftPractica/ASP_Obl.git
```

- Gemfile dependencies

```ruby
bundle install
```

- Creating the database

```bash
rake db:create
```

- Running Migrations

```bash
rake db:migrate
```

- Download and run Docker Container of Loggly

```bash
sudo docker run -d -p 514/udp --name loggly-docker -e TOKEN=TOKEN -e TAG=Docker sendgridlabs/loggly-docker
```
> Replace: TOKEN: your customer token from the source setup page

- Adding config of Logglier to config/environments/<environment>.rb
 
```ruby
require 'logglier'
config.logger = Logglier.new("https://logs-01.loggly.com/inputs/TOKEN/tag/ruby/", :threaded => true)
```
> Replace: TOKEN: your customer token from the source setup page

## Testing instructions

- Run the command
 
```ruby
rake test
```

## Deployment instructions

- Download repository

```bash
git clone https://github.com/ArqSoftPractica/ASP_Obl.git
```
 
- Gemfile dependencies

```ruby
bundle install
```

- Create new app in Heroku webpage named app-coupons

- Login in Heroku via terminal

```bash
heroku login
```

- Create a new Heroku repository

```bash
heroku git:remote -a app-coupons
```

- Setting buildpack default for the application

```bash
heroku buildpacks:set heroku/ruby
```

- Pushing to Heroku repository

```bash
git push heroku master
```

- Adding environment variables to Heroku

```bash
DATABASE_URL = ...
LANG = en_US.UTF-8
MAIL_PASSWORD = ...
MAIL_ADDRESS = ...
RACK_ENV = production
RAILS_ENV = production
RAILS_LOG_TO_STDOUT = enabled
RAILS_SERVE_STATIC_FILES = enabled
SECRET_KEY_BASE = ...
```

- Running Migrations

```bash
heroku run db:migrate
```

- Configure Loggly in Heroku

```bash
heroku drains:add http://logs-01.loggly.com/bulk/TOKEN/tag/heroku --app HEROKU_APP_NAME
```
> Replace TOKEN: your customer token from the source setup page
> Replace HEROKU_APP_NAME: your Heroku App name

## Managing the deployed app

```bash
heroku apps                       (list the deployed apps)
heroku apps:info                  (details of an app)
heroku -h                         (help)
heroku logs --tail                (logs)
heroku run rake db:migrate        (apply migrations)
heroku ps                         (process status)
heroku open                       (start the app)
heroku run rails console          (run rails console)
heroku run bash                   (start server console)
heroku git:remote -a app-coupons  (add remote for Git)

git push heroku develop:master    (ramaOrig:ramaDest)
```
