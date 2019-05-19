require_relative '../bakery.rb'

describe Bakery do
  subject(:bakery) { described_class.new()}

  describe "#initialize" do
      it "initializes stock" do
        expect(bakery.instance_variable_get(:@stock).to_a).
        to eq([[:code, :amount, :cost],
              ["VS5", "3", "6.99"],
              ["VS5", "5", "8.99"],
              ["MB11", "2", "9.95"],
              ["MB11", "5", "16.95"],
              ["MB11", "8", "24.95"],
              ["CF", "3", "5.95"],
              ["CF", "5", "9.95"],
              ["CF", "9", "16.99"]]
        )
      end

      it "initializes orders" do
        expect(bakery.instance_variable_get(:@orders).to_a).
        to eq([[:code, :amount],
              ["VS5", "10"],
              ["MB11", "14"],
              ["CF", "13"],
              ["VS5", "0"],
              ["VS5", "400"],
              ["KX", "1321"],
              ["VS5", "qwerty"],
              ["VS5", "1412412412"]]
        )
      end
  end

  describe "#process" do
    it "rescues wrong order data" do
      expect { bakery.process }.not_to raise_error(ArgumentError)
      expect { bakery.process }.not_to raise_exception(SystemStackError)
    end
  end
end
