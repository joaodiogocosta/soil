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
  * [Params](#params)
  * [Response](#response)
    * [JSON](#json)
    * [Render Templates](#render-templates)
    * [Inline HTML](#inline-html)
    * [Text](#text)
  * [Hooks](#hooks)
  * [Namespaces](#namespaces)
  * [Nested Routes](#nested-routes)
* [Views and Layouts](#views-and-layouts)
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

An `Action` is a plain Crystal object that includes `Soil::Action`, which is a module that ensures a proper `call` method is implemented:

```crystal
class PostsIndexAction
  include Soil::Action

  def call(req, res)
    posts = [...]
    res.json(posts)
  end
end

class PostsApp < Soil::App
  get "/", PostsIndexAction.new
end
```

This is particularly useful for endpoints that incorporate a considerable amount of operations, such as an enpoint that creates a new User account:

```crystal
class CreateUserAction
  include Soil::Action

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

Routes can have multiple handlers. `Proc` and `Action` can be combined in arrays:

```crystal
class LogAction
  include Soil::Action

  def call(req, res)
    # Log something to STDOUT
  end
end

class PostsIndexAction
  include Soil::Action

  def call(req, res)
    posts = [...]
    res.json(posts)
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

### Params

#### URL

URL named parameters are captured and accessible via `req.params.url`:

```crystal
class BlogApp < Soil::App
  get "/posts/:post_id/comments/:comment_id" do |req, res|
    req.params.url["post_id"] # => "45"
    req.params.url["comment_id"] # => "87"
  end
end
```

#### Query

Query parameters are accessible via `req.params.query`:

```crystal
class BlogApp < Soil::App
  get "/posts?search=crystal" do |req, res|
    req.params.query["search"] # => "crystal"
  end
end
```

#### JSON

JSON parameters are captured from the body and accessible via `req.params.json`.

Given the following JSON payload:

```json
{
  "post": {
    "title": "Soil is pure awesomeness!"
  }
}
```

Here's how you would access its values:

```crystal
class BlogApp < Soil::App
  post "/posts" do |req, res|
    req.params.json["post"]["title"] # => "Soil is pure awesomeness!"
  end
end
```

### Response

#### JSON

Soil has built-in support for JSON responses. The following will call `to_json` on the object passed in as argument and write to the response body.

```crystal
class Api < Soil::App
  get "posts" do |req, res|
    posts = [...]
    res.json(posts)
  end
end
```

This method will set the `Content-Type` header to `application/json`.

#### Render Templates

Render any template (HTML or others) by calling `render` on the response object and passing any `View` class. Read more about views [here](#views).

```crystal
class MyApp < Soil::App
  get "/" do |req, res|
    res.render(IndexView)
  end
end
```

This method will set the `Content-Type` header to `text/html`.

#### Inline HTML

For inline HTML:

```crystal
class HtmlApp < Soil::App
  get "/" do |req, res|
    res.html("<html></html>")
  end
end
```

This method will set the `Content-Type` header to `text/html`.

#### Text

For simple plain text responses:

```crystal
class TextApp < Soil::App
  get "/" do |req, res|
    res.text("Soil says hi!")
  end
end
```

This method will set the `Content-Type` header to `text/plain`.

### Hooks

Hooks are evaluated before or after each request within the same context of the request. They run before/after every request defined within the App or within mounted Apps.

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

### Nested Routes

Nested Routes are the foundation of Soil's extensibility features.

Soil Apps can be combined to create complex applications of multiple endpoints with multiple levels of nesting.

```crystal
class Users < Soil::App
  get "/" do |req, res|
    users = [...]
    res.json(users)
  end
end

class Comments < Soil::App
  get "/" do |req, res|
    # ...
    req.params["post_id"] => # 231
    # ...
  end
end

class Posts < Soil::App
  mount ":post_id/comments", CommentsApp

  get "/" do |req, res|
    posts = [...]
    res.json(posts)
  end
end

class BlogApp < Soil::App
  namespace "blog"

  mount "/users", UsersApp
  mount "/posts", PostsApp
end
```

This will generate the following routes:

`GET /blog/users`

`GET /blog/posts`

`GET /blog/posts/:post_id/comments`

### Views and Layouts

Views and templating engines are a crucial part of every web framework. Soil's approach is to provide enough flexibility to the developer while enforcing good practices, such as having a reasonably well-defined data structure.

First create a new file that will act as the template. Soil uses Crystal's built-in templating engine [ECR](https://crystal-lang.org/api/ECR.html):

```html
(index.html.ecr)

<p>I Love <%= name %>!</p>
```

Then declare a new class that will act as the data container for the view
template:

```crystal
class IndexView
  include Soil::View

  def initialize(data)
    @name = data["name"]
  end

  def name
    @name
  end

  def render(io : IO)
    render_template io, "index.html.ecr"
  end
end
```

It's mandatory to implement a `render(io : IO)` method. You can return whatever
you want, in this case we will return a pre-compiled template.

Views are plain Crystal objects, you are free to implement them as you find more suitable to your needs, just remember to make publicly accessible the methods that are used in the template (`name` in this case).

Ultimately, reference it in your request handler by calling `render` just like any `text` or `JSON` response:

```crystal
class MyApp < Soil::App
  get "/" do |req, res|
    res.render(IndexView, { "name" => "Crystal" })
  end
end
```

The result will be:

```
<p>I love Crystal!<p>
```

#### Layouts

Soil supports View Layouts.

Given a layout template, add the placeholder `yield_contents` to where you want to render a nested template:

```html
(layout.html.ecr)

<div>
  <%= yield_contents %>
</div>
```

And then reference this file in the View:

```crystal
class IndexView
  include Soil::View

  def render(io : IO)
    render_template io, "index.html.ecr", layout: "index.html.ecr"
  end
end
```

The contents of `index.html.ecr` will replace `<%= yield_contents %>` in the layout.

### Configuration

As of now, Soil accepts configuration options for the following parameters:

```crystal
class BlogApp < Soil::App
  configure do |config|
    config.host = "example.org"
    config.port = "8080"
  end

  # ...
end
```

## Requirements

Crystal - Please refer to http://crystal-lang.org/docs/installation for instructions for your operating system.

## Contributing

Everyone is invited to make Soil a better project:

1. Fork it ( https://github.com/joaodiogocosta/soil/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

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
