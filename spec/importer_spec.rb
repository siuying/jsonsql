require 'spec_helpers'
require 'date'
require 'sequel'

describe Jsonsql::Importer do
  subject { Jsonsql::Importer.new("samples/mtr") }

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

  context "#import" do
    it "should import all files on the path" do
      # 43 files in the sample path
      expect(subject).to receive(:import_jsonfile).exactly(43).times

      subject.import
    end

    it "populate database after import" do
      subject.import

      expect(subject.table).to_not be_nil
      expect(subject.table.count).to eq(43)
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
end