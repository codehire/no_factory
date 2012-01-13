require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "NoFactory" do
  let(:mock_test_obj) { Hash.new }

  module TestFactory
    def test_object
      mock_test_obj
    end

    def test_object_with_params(opts)
      mock_test_obj.tap {|o| o.merge!(opts) }
    end

    def test_object_with_params_and_block(opts, &block)
      test_object_with_params(opts).tap(&block)
    end
  end

  describe "bog standard" do
    factory :test

    it "should return the test object" do
      test_object.should == mock_test_obj
    end

    it "should call save! if banged" do
      mock_test_obj.should_receive(:save!)
      test_object!.should == mock_test_obj
    end

    it "should pass params to the object" do
      test_object_with_params(name: "foo")[:name].should == "foo"
    end

    it "should pass params to the object when banged" do
      mock_test_obj.should_receive(:save!)
      test_object_with_params!(name: "bar")[:name].should == "bar"
    end

    it "should pass params and block to the object" do
      obj = test_object_with_params_and_block(name: "foo") do |o|
        o[:value] = "bar"
      end
      obj[:name].should == "foo"
      obj[:value].should == "bar"
    end

    it "should pass the params and the block to the object when banged" do
      mock_test_obj.should_receive(:save!)
      obj = test_object_with_params_and_block!(name: "foo") do |o|
        o[:value] = "bar"
      end
      obj[:name].should == "foo"
      obj[:value].should == "bar"
    end
  end

  describe "overriding the banged method" do
    factory :test, on_bang: :bang_it

    it "should call my banged method" do 
      mock_test_obj.should_receive(:bang_it)
      test_object!.should == mock_test_obj
    end
  end
end
