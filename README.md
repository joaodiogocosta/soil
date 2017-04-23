# Soil

Soil is a Web Framework written in Crystal optimized for productivity and extensibility.

[![Build Status](https://travis-ci.org/joaodiogocosta/soil.svg?branch=master)](https://travis-ci.org/joaodiogocosta/soil)

It is inspired by the most well known Ruby and Javascript web frameworks, inheriting the completeness of Ruby on Rails, the clarity and readability of ExpressJS and the simplicity of Sinatra.

## Current state

Soil is still a work in progress with a lot of missing features, but it will be constantly updated until it reaches a stable version.

## Installation

Add Soil to `shard.yml`:

```yaml
dependencies:
  soil:
    github: joaodiogocosta/soil
    branch: master
```

And then run:

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
  * [Handlers](#handlers)
  * [Request](#request)
  * [Params](#params)
  * [Response](#response)
  * [Hooks](#hooks)
  * [Namespaces](#namespaces)
* [Configuration](#configuration)

## Routes

### Definition

Defining routes is extremely easy.

First, define a class that acts as a routes container, such as a Controller does in other web frameworks, and then define an arbitrary amount of routes by using methods such as `get` and passing a block handler that accepts `req` (request) and `res` (response) as arguments.

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

### Handlers

A Route accepts two different types of handlers, crystal's built-in [Proc](https://crystal-lang.org/docs/syntax_and_semantics/literals/proc.html) and [Action](#action).

#### Proc

A `Proc` is the simplest handler. To use it, simply pass in a block that accepts `req` (request) and `res` (response) as arguments:

```crystal
class BlogApp < Soil::App
  get "/" do |req, res|
    # ...
  end
end
```

#### Action

`Action` is a basic class that inherit from `Soil::Action`, which is just an absctract class that ensures that a `call` method is implemented:

```crystal
class PostsIndexAction < Soil::Action
  def call(req, res)
    @posts = [...]
    res.json(@posts)
  end
end

class PostsApp < Soil::App
  get "/", PostsIndexAction.new
end
```

This is particularly useful for endpoints that incorporate a considerable amount of operations, such as an enpoint that creates a new User account:

```crystal
class CreateUserAction < Soil::Action
  def initialize
    @email_sender = EmailSender.new
  end

  def call(req, res)
    user = create_user(req.params["user"])

    if user
      send_welcome_email(user)
      res.json(user)
    else
      res.status_code = 400
      res.json("message" => "Could not create User")
    end
  end

  private def create_user(attributes)
    User.create(attributes)
  end

  private def send_welcome_email(user)
    @email_sender.send(:welcome_email, user.email)
  end
end
```

And then use it in a Route:

```crystal
class BlogApp < Soil::App
  get "/", CreateUserAction.new
end
```

#### Multiple Handlers

Routes can have multiple handlers.

`Proc`s and `Action`s can be combined in arrays:

```crystal
class LogAction < Soil::Action
  def call(req, res)
    # Log something to STDOUT
  end
end

class PostsIndexAction < Soil::Action
  def call(req, res)
    @posts = [...]
    res.json(@posts)
  end
end

class PostsApp < Soil::App
  get "/", [
    LogAction.new,
    PostsIndexAction.new,
    -> (req : Soil::Http::Request, res : Soil::Http::Response) {
      # ...
    }]
end
```

### Request

TODO

### Params

TODO

### Response

TODO

### Hooks

```crystal
class Posts < Soil::App

  before do |req, res|
    pp req.params # print params before handler
  end

  after do |req, res|
    pp res.status_code # print status code after handler
  end

  # ...
end
```

### Namespaces

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

Namespaces are propagated to all routes.

### Configuration

TODO

### Composition

TODO

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
