require 'spec_helper'

describe GrantFront::Policy do
  describe ".all" do
    it "returns a policy" do
      expect(GrantFront::Policy.all.count).to eq(1)
    end
  end

  describe ".find" do
    let(:policy) { GrantFront::Policy.all.first }

    it "returns some methods" do
      expect(GrantFront::Policy.find(policy)[:methods].keys).to eq([:create, :update, :destroy])
    end

    it "returns some roles" do
      expect(GrantFront::Policy.find(policy)[:roles]).to eq([:foo, :bar, :baz])
    end
  end
end
