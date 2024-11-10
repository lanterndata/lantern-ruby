# Lantern Ruby Client

[![codecov](https://codecov.io/gh/lanterndata/lantern-ruby/branch/main/graph/badge.svg)](https://codecov.io/gh/lanterndata/lantern-ruby)

No Ruby client is required for `pg` or `Sequel`. For `ActiveRecord` and `Rails`, you can use the `lantern` gem.

## Features

- Perform nearest neighbor queries over vectors
- Create text embeddings using open-source models

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

### Vector search

The Lantern gem integrates with ActiveRecord to provide vector similarity search capabilities:

```ruby
class Document < ApplicationRecord
  # Enable vector similarity search for one or more columns
  has_neighbors :embedding
end

# Class-level nearest-neighbor search: find nearest neighbors for a given vector
Document.nearest_neighbors(:embedding, vector, distance: 'l2')

# Instance-level nearest-neighbor search: find nearest neighbors for a given instance
document = Document.first
document.nearest_neighbors(:embedding, distance: 'l2')
```

Supported distance metrics:

- `l2` (Euclidean distance)
- `cosine` (Cosine similarity)

### Embedding generation

```ruby
# Generate embeddings using a specific model
embedding = Lantern.generate_embedding('BAAI/bge-base-en', 'Your text here')
```

A full list of supported models can be found [here](lantern.dev/docs/develop/generate).

## Rails

For Rails, enable the Lantern extension using the provided generator:

```bash
rails generate lantern:install
rails db:migrate
```
