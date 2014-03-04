require 'spec_helpers'
require 'date'
require 'sequel'

describe Jsonsql::Transformer do
  context "::new" do
    it "create a transformer with block" do
      transformer = Jsonsql::Transformer.new do |row|
        row[:name] = row[:name].downcase if row[:name]
        row
      end

      data = transformer.transform({:name => "Peter", :id => 1})
      expect(data).to eq({:name => "peter", :id => 1})
    end
  end

  context "::transformer_with_string" do
    it "create a transformer with block" do
      transformer = Jsonsql::Transformer.transformer_with_string "
      Proc.new { |row| row[:name] = row[:name].downcase if row[:name]; row } 
      "
      data = transformer.transform({:name => "Peter", :id => 1})
      expect(data).to eq({:name => "peter", :id => 1})
    end
  end
end