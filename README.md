# GrantFront

[![Gem Version](https://badge.fury.io/rb/grant-front.svg)](http://badge.fury.io/rb/grant-front) [![Build Status](https://travis-ci.org/ogom/grant-front.png?branch=master)](https://travis-ci.org/ogom/grant-front)

Policies grant of role for authorization on Rails.

## Installation

Add this line to your application's Gemfile:

```
gem 'grant-front'
```

And then execute:

```
$ bundle
```

## Usage

### Rack

Add this line to your `config/routes.rb`:

```
mount GrantFront::Engine, at: '/rails/info/policies'
```

Draw by selecting the policy:

![example](http://ogom.github.io/grant-front/assets/img/example.png)

### Rake

Draw by rake command:

```
$ rake grant_front:draw

### User

||foo|bar|baz|
|:-|:-:|:-:|:-:|
|create|o|o|o|
|update|o|o||
|destroy||o|o|
```

## Policy Example

Install the [Pundit](https://github.com/elabs/pundit), and to the generate:

```
$ rails generate pundit:install
$ rails generate pundit:policy user
```

Include **GrantFront** line to your `policies/application_policy.rb`:

```
class ApplicationPolicy
  include GrantFront
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
end
```

Add **grant** line to your `policies/user_policy.rb`:

```
class UserPolicy < ApplicationPolicy
  def create?
    grant :foo, :bar, :baz
  end

  def update?
    grant :foo, :bar
  end

  def destroy?
    grant :bar, :baz
  end
end
```

## License

* MIT
