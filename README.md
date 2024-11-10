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

### Create a model

```ruby
ActiveRecord::Migration.create_table :movies do |t|
  t.column :movie_embedding, :real, array: true
end
@conn.execute("INSERT INTO movies (movie_embedding) VALUES ('{0,1,0}'), ('{3,2,4}')")
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

### Vector index

To speed up vector search queries, you can add an HNSW index to your model:

```ruby
class CreateVectorIndex < ActiveRecord::Migration[7.0]
  def up
    add_index :books, :embedding, using: :lantern_hnsw, opclass: :dist_l2sq_ops, name: 'book_embedding_index'
  end
  def down
    remove_index :books, name: 'book_embedding_index'
  end
end
```

Note: This does not support `WITH` parameters (e.g., `ef_construction`, `ef`, `m`, `dim`).

To specify `WITH` parameters, you can pass them as options with raw SQL:

```ruby
class CreateHnswIndex < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE INDEX movie_embedding_hnsw_idx 
      ON movies 
      USING lantern_hnsw (movie_embedding dist_l2sq_ops) 
      WITH (
        ef = 15,
        m = 16,
        ef_construction = 64
      )
    SQL
  end
  def down
    drop index movie_embedding_hnsw_idx
  end
end
```

## Rails

For Rails, enable the Lantern extension using the provided generator:

```bash
rails generate lantern:install
rails db:migrate
```
