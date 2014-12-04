# GrantFront

[![Gem Version](https://badge.fury.io/rb/grant-front.svg)](http://badge.fury.io/rb/grant-front) [![Build Status](https://travis-ci.org/ogom/grant-front.png?branch=master)](https://travis-ci.org/ogom/grant-front)

Authorization Grant Front on Rails.

## Installation

Add this line to your application's Gemfile:

```
gem 'grant-front'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install grant-front
```

## Usage

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

```
$ rake grant_front:draw
```

||foo|bar|baz|
|:-:|:-:|:-:|:-:|
|create|o|o|o|
|update|o|o||
|destroy||o|o|


## License

* MIT
