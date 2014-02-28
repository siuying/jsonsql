module Jsonsql
  class Transformer
    def initialize(&block)
      @transformation = block
    end

    def transform(row)
      self.instance_exec(row, &@transformation)
    end

    def self.transformer_with_block(string)
      block = eval(string)
      Transformer.new(&block)
    end
  end
end