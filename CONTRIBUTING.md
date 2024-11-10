# Contributing to lantern-ruby

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

3. Set the environment variables in a `.env` file or in the environment.

    ```bash
    DATABASE_URL= # Required
    COHERE_TOKEN=
    OPENAI_TOKEN=
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

## Release

To release a new version, update the version number in `version.rb`, and then run:

```bash
bundle exec rake release
```

## Roadmap

* Support creating vector indexes
* Support creating embedding jobs
