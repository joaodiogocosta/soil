module Outer
  module Inner
    def self.inner_method
      outer_method
    end
  end

  def self.outer_method
    puts "funca!"
  end
end

Outer::Inner.inner_method
