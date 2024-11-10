# Lantern Ruby Client

[![codecov](https://codecov.io/gh/lanterndata/lantern-ruby/branch/main/graph/badge.svg)](https://codecov.io/gh/lanterndata/lantern-ruby)

No Ruby client is required for `pg` or `Sequel`. For `ActiveRecord` and `Rails`, you can use the `lantern` gem.

## Features

- Perform nearest neighbor queries over vectors using vectors or text
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

This gem provides several ways to perform vector search. We support the following distance metrics:

- `l2` (Euclidean distance)
- `cosine` (Cosine similarity)

Using pre-computed vectors:

```ruby
class Document < ApplicationRecord
  has_neighbors :embedding
end

# Find 5 nearest neighbors using L2 distance 
Document.nearest_neighbors(:embedding, [0.1, 0.2, 0.3], distance: 'l2').limit(5)

# Given a document, find 5 nearest neighbors using cosine distance
document = Document.first
document.nearest_neighbors(:embedding, distance: 'cosine').limit(5)
```

Using text:

```ruby
class Book < ApplicationRecord
  has_neighbors :embedding
end

# Find 5 nearest neighbors using open-source model
Book.nearest_neighbors(:embedding, 'The quick brown fox', model: 'BAAI/bge-small-en', distance: 'l2').limit(5)

# Find 5 nearest neighbors using OpenAI
Lantern.set_api_token(openai_token: 'your_openai_token')
Book.nearest_neighbors(:embedding, 'The quick brown fox', model: 'openai/text-embedding-3-small', distance: 'cosine').limit(5)
```

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
