# Lantern Ruby Client

[![codecov](https://codecov.io/gh/lanterndata/lantern-ruby/branch/main/graph/badge.svg)](https://codecov.io/gh/lanterndata/lantern-ruby)

No Ruby client is required for `pg` or `Sequel`. For `ActiveRecord` and `Rails`, you can use the `lantern` gem.

## Features

- Perform nearest neighbor queries over vectors
- Create text embeddings using various models

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'lantern'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install lantern
```

## ActiveRecord

## Rails

```bash
rails generate lantern:install
rails db:migrate
```
