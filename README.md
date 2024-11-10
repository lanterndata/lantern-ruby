# Lantern Ruby Client

[![codecov](https://codecov.io/gh/lanterndata/lantern-ruby/branch/main/graph/badge.svg)](https://codecov.io/gh/lanterndata/lantern-ruby)

No Ruby client is required for `pg` or `Sequel`. For `ActiveRecord` and `Rails`, you can use the `lantern` gem.

## Features

- Perform nearest neighbor queries over vectors
- Create text embeddings using OpenAI, Cophere, and open-source models

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
embedding1 = Lantern.text_embedding('BAAI/bge-base-en', 'Your text here')

Lantern.set_api_token(openai_token: 'your_openai_token')
embedding2 = Lantern.openai_embedding('text-embedding-3-small', 'Hello')

Lantern.set_api_token(cohere_token: 'your_cohere_token')
embedding3 = Lantern.cohere_embedding('embed-english-v3.0', 'Hello')
```

A full list of supported models can be found [here](lantern.dev/docs/develop/generate).

## Rails

For Rails, enable the Lantern extension using the provided generator:

```bash
rails generate lantern:install
rails db:migrate
```
