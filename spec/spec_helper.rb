require 'grant-front'

class ApplicationPolicy
  include GrantFront
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end
end

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
