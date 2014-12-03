require 'grant-front'

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  private
    def grant(*roles)
      roles.each do |role|
        return true if user.roles.include? role
      end
      return false, roles
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
