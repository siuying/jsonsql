require 'spec_helpers'
require 'date'
require 'sequel'

describe Jsonsql::Importer do
  subject { Jsonsql::Importer.new("samples/mtr") }

  context "#columns_with_row" do
    it "should find columns with a row of data" do
      data = {"text" => "Hello World", "created_at" => DateTime.now, "id" => 123456}
      columns = subject.columns_with_row(data)

      expect(columns).to_not be_nil
      expect(columns).to eq({"text" => String, "created_at" => DateTime, "id" => Fixnum})
    end

    it "should raise error when row contains unsupported class" do
      data = {"text" => "Hello World", "created_at" => DateTime.now, "id" => 123456, "tags" => ["1", "2", "3"]}

      expect {
        subject.columns_with_row(data)
      }.to raise_error(ArgumentError)
    end
  end

  context "#import_jsonfile" do
    it "import one json file to db" do
      subject.import_jsonfile("samples/mtr/437582112921640960.json")

      expect(subject.table).to_not be_nil
      expect(subject.table.count).to eq(1)
      expected_row = {
        :id => 437582112921640960,
        :text => "@kaede19940908 圖片係港鐵官方的",
        :created_at => "2014-02-23 21:38:00 +0800",
        :lang => "zh",
        :reply_to => "kaede19940908"
      }
      expect(subject.table.where(:id => 437582112921640960).to_a).to eq([expected_row])
    end
  end

  context "#import_path" do
    it "should import all files on the path" do
      # 43 files in the sample path
      expect(subject).to receive(:import_jsonfile).exactly(43).times

      subject.import_path("samples/mtr")
    end
  end
end