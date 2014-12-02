# GrantFront

[![Gem Version](https://badge.fury.io/rb/grant-front.png)](https://rubygems.org/gems/grant-front) [![Build Status](https://travis-ci.org/ogom/grant-front.png?branch=master)](https://travis-ci.org/ogom/grant-front)

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
class UserPolicy < ApplicationPolicy
  def create?
    grant :foo, :bar, :baz
  end

  def grant(*roles)
    roles.each do |role|
      return true if user.roles.include? role
    end
    return false, roles
  end
end
```

```
$ rake grant_front:draw
```

||foo|bar|baz|
|:-:|:-:|:-:|:-:|
|create|o|o|o|
|new|o|o|o|


## License

* MIT
