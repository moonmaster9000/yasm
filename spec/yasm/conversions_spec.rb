require 'spec_helper'

describe Yasm::Conversions::Symbol do
  it "should create a :to_class instance method on Symbols" do
    :sym.respond_to?(:to_class).should be_true
  end
end

describe Symbol do
  describe "#to_class" do
    it "should convert the symbol to a class" do
      class SymbolTest; end
      :symbol_test.to_class.should == SymbolTest
    end

    it "should be the inverse of the Class #to_sym class method" do
      class SymbolTest; end
      :symbol_test.to_class.to_sym.should == :symbol_test
    end
  end
end


describe Yasm::Conversions::Class do
  it "should create a :to_sym class method on classes" do
    class SymbolTest; end
    SymbolTest.respond_to?(:to_sym).should be_true
  end
end

describe Symbol do
  describe "#to_sym" do
    it "should convert the class to a symbol" do
      class SymbolTest; end
      SymbolTest.to_sym.should == :symbol_test
    end

    it "should be the inverse of the Symbol #to_class instance method" do
      class SymbolTest; end
      SymbolTest.to_sym.to_class.should == SymbolTest
    end
  end
end
