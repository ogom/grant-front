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
  def index?
    grant :admin, :foo, :bar
  end

  def create?
    index?
  end

  def grant(*roles)
    if GrantFront.store
      GrantFront.authorizations.last[:roles] = roles
    else
      roles.each do |role|
        return true if user.roles.include? role
      end
      false
    end
  end
end
```

```
$ rake grant_front:draw
| class | method | roles |
|:-----:|:------:|:-----:|
| UserPolicy | index? | admin,foo,bar |
| UserPolicy | create? | admin,foo,bar |
```

## License

* MIT
