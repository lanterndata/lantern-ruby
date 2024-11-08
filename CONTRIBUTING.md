# Contributing to lantern-ruby

# Lantern Ruby Clients

## Prerequisites

* Ruby: Version 3.1 or higher
* Bundler: Version 2.2 or higher
* Postgres database with Lantern extensions installed

## Installation

1. Fork this repository to your own GitHub account and then clone it to your local device.

    ```bash
    git clone https://github.com/your-username/lantern-ruby.git
    cd lantern-ruby
    ```

2. Install dependencies.

    ```bash
    bundle config set path 'vendor/bundle'
    bundle install
    ```

3. Set DB_URL in environment or in `.env` file.

    ```bash
    export DATABASE_URL=postgresql://user:password@localhost:5432/lantern
    ```

## Style guide

To check for linting errors:

```bash
bundle exec rubocop
```

To automatically fix linting errors:

```bash
bundle exec rubocop -a
```

## Running tests

Run all tests:

```bash
bundle exec rake test
```

Run a specific test:

```bash
bundle exec rake test TEST=test/path/to/your_test_file.rb
```

## Roadmap

### In Progress

* Support nearest neighbor queries

### Future

* Support creating vector indexes
* Support creating embedding jobs
