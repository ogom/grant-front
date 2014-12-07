require 'spec_helper'

describe GrantFront::Diagram do
  describe "#create" do
    let(:diagram) { GrantFront::Diagram.new(classes: ['UserPolicy']) }

    it "returns diagram" do
      expect(diagram.create).to eq(
        "\n### User\n" +
        "\n" +
        "||foo|bar|baz|\n" +
        "|:-|:-:|:-:|:-:|\n" +
        "|create|o|o|o|\n" +
        "|update|o|o||\n" +
        "|destroy||o|o|\n"
      )
    end
  end
end
