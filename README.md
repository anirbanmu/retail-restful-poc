# retail-restful-poc

A proof-of-concept application that supports storing pricing data for products & combines stored price with other product information from external source.

## Dependencies
- Ruby on Rails
- Redis

## Getting started (skip to Heroku instructions if you don't want to run locally)
- Install Ruby (try this [how-to](https://www.ruby-lang.org/en/documentation/installation/) if you need instructions)
- Install & start Redis - `sudo apt-get install redis-server` (Ubuntu) or follow the [Redis guide](https://redis.io/topics/quickstart)
- Install `bundler` gem - `gem install bundler`
- Clone this repo
- Run `bundle install` from the repo directory to install all gem dependencies

## Starting the application
- `bundle exec rails server` will start the application

## Usage
After having started the server locally, you can make requests to http://localhost:3000/products/{#id}. Both APIs require that the product ID has an entry in Redis.
#### Fetch
- Fetches data about a particular product ID
- `curl https://desolate-gorge-89429.herokuapp.com/products/13860428`
#### Update
- Updates the information for a product ID & also returns the same data as the fetch API on success
- `curl -X PUT http://localhost:3000/products/13860428 -H "Content-Type: application/json" -d '{"current_price":{"value":1.99,"currency_code":"USD"}}'`

## Running tests
- This assumes you've completed the Getting started section above
- Run `bundle exec rspec` to run RSpec tests

## Heroku setup
- Clone this repo
- Install the Heroku toolbelt. Follow this [guide](https://devcenter.heroku.com/articles/heroku-cli)
- Create a Heroku application from the repo directory via `heroku create`
- Add the Redis addon to the Heroku application `heroku addons:create heroku-redis:hobby-dev`
- Push the master branch to Heroku, `git push heroku master`
- Heroku will deploy your application & provide you its URL

## How to populate Redis with product information
There is no way to currently populate data into Redis externally.

#### Local
To manually test locally, start the Rails application as instructed above & then run `rails console` from the repo directory in another shell window. To add an entry to Redis, I suggested executing something like this from the live Rails console:
>`Product.new(id: 13860428, price: 19.99, currency: 'USD').save`

Be aware that the changes you make to Redis will be wiped (when in a development environment) on next Rails application start.

#### Heroku
After having deployed to Heroku, you can get to the Rails console on the Heroku instance via `heroku run rails console` from the repo directory. After the console comes up, you can create entries the same way as locally (see above).

## Live example
This application is live @ https://desolate-gorge-89429.herokuapp.com as an example. It's currently only populated with one product ID (13860428). You're welcome to play with it via https://desolate-gorge-89429.herokuapp.com/products/13860428

## Main Ruby gems used
- Rails (main application framework)
- RSpec (testing framework)
- factory_bot (creating adhoc model instances)
- VCR (record & playback HTTP requests)
- redis-namespace (provides an redis interface with a namespace prepended)
- money (used to verify valid currency)

## Source code locations of interest
- `app/controllers/products_controllers.rb` - Implements controller for Products REST API
- `app/models/product.rb` - Product model (interfaces to Redis as well)
- `lib/redsky_api.rb` - Module that provides an interface to Redsky API
- `spec` - RSpec specs testing all implemented modules/classes
