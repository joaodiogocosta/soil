# Soil

Soil is a Web Framework written in Crystal optimized for productivity and extensibility.

[![Build Status](https://travis-ci.org/joaodiogocosta/soil.svg?branch=master)](https://travis-ci.org/joaodiogocosta/soil)

It is inspired by the most well known Ruby and Javascript web frameworks, inheriting the completeness of Ruby on Rails, the clarity and readability of ExpressJS and the simplicity of Sinatra.

## Current state

Soil is still a work in progress with a lot of missing features, but it will be constantly updated until it reaches a stable version.

## Instalation

Add Soil to `shard.yml`:

```yaml
dependencies:
  soil:
    github: joaodiogocosta/soil
    branch: master
```

And then:

```
$ crystal deps
```

## Basic Example

The following is a basic example that defines a `GET /posts` endpoint and responds with JSON.

```crystal
# blog_app.cr

class BlogApp < Soil::App
  get "posts" do |req, res|
    posts = [...]
    res.json(posts)
  end
end

BlogApp.new.run
```

And then run:

```
$ crystal blog_app.cr
```

## Table of Contents

* [Routes](#routes)
  * [Definition](#definition)
  * [Conditions](#definition)
  * [Request](#request)
  * [Params](#response)

## Routes

### Definition

Defining routes is extremely easy.

First, define a class that acts as a routes container, such as controller does in other web frameworks, and then define an arbitrary amount of routes by using methods such as `get` and passing a block handler that accepts `req` (request) and `res` (response) as arguments.

```crystal
class BlogApp < Soil::App
  get "/" do |req, res|
    # ...
  end

  post "/" do |req, res|
    # ...
  end
end
```

### Composition

```crystal
class Posts < Soil::App
  get "/" do |req, res|
    posts = [...]
    res.json(posts)
  end
end

class BlogApp < Soil::App
  mount "/posts", Posts
end
```

### Hooks

```crystal
class Posts < Soil::App

  before do |req, res|
    pp req.params # print params before handler
  end

  after do |req, res|
    pp res.status_code # print status code after handler
  end

  get "/" do |req, res|
    posts = [...]
    res.json(posts)
  end
end
```

### Use Classes As Handlers

Route handlers can be extracted to their own class, which is useful to implement complex endpoints with lots of logic, causing the route definition to look much more clean.

```crystal
class PostsIndex < Soil::Action
  def initialize
    @posts = [...]
  end

  def call(req, res)
    res.json(@posts)
  end
end

class Posts < Soil::App
  get "/", PostsIndex
end
```

### Routing Namespaces

The following wil prepend `blog` to all routes, hence `/blog/posts`:

```crystal
class BlogApp < Soil::App
  namespace "blog"

  get "posts" do |req, res|
    posts = [...]
    res.json(posts)
  end
end
```

## Requirements

Crystal - Please refer to http://crystal-lang.org/docs/installation for instructions for your operating system.

## Contributing

TODO

## License

MIT License

Copyright (c) 2017 João Diogo Costa

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
