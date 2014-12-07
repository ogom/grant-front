require 'spec_helper'

describe GrantFront::Policy do
  describe ".all" do
    let(:policy) { GrantFront::Policy.all.first}

    it "returns klass of policy" do
      expect(policy.klass).to eq('UserPolicy')
    end

    it "returns name of policy" do
      expect(policy.name).to eq('User')
    end

    it "returns urn of policy" do
      expect(policy.urn).to eq('user')
    end
  end

  describe ".find" do
    let(:klass) {GrantFront::Policy.all.first.klass}

    it "returns some methods" do
      expect(GrantFront::Policy.find(klass).methods.keys).to eq([:create, :update, :destroy])
    end

    it "returns some roles" do
      expect(GrantFront::Policy.find(klass).roles).to eq([:foo, :bar, :baz])
    end
  end
end
