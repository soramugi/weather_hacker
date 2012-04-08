# encoding: UTF-8

require "spec_helper"

describe "WeatherHacker::Client" do
  before do
    @client = WeatherHacker::Client.new
    @zipcode = "690-0261"
  end

  describe "#get_weather" do
    before do
      @result = @client.get_weather(@zipcode)
    end

    it "get parsed weather data in Hash" do
      [Hash, NilClass].should be_include @result.class
    end

    it "has weather" do
      @result["weather"].should =~ /[晴曇雨]/
    end

    it "has max and min temperature" do
      @result["temperature"].has_key?("max").should be_true
      @result["temperature"].has_key?("min").should be_true
    end
  end

  shared_examples_for "having area table" do
    it "has area table" do
      @client.send(:id_by_city).keys.size.should_not == 0
      @client.send(:pref_by_city).keys.size.should_not == 0
    end
  end

  shared_examples_for "not having area table" do
    it "has not area table" do
      @client.instance_variable_get(:@id_by_city).should be_nil
      @client.instance_variable_get(:@pref_by_city).should be_nil
    end
  end

  describe "#id_by_city" do
    context "before call" do
      it_behaves_like "not having area table"
    end

    context "after call" do
      before { @client.send(:id_by_city) }
      it_behaves_like "having area table"
    end
  end

  describe "#pref_by_city" do
    context "before call" do
      it_behaves_like "not having area table"
    end

    context "after call" do
      before { @client.send(:pref_by_city) }
      it_behaves_like "having area table"
    end
  end

  describe "#city_id_by_zipcode" do
    it "return city_id" do
      city_id = @client.send(:city_id_by_zipcode, @zipcode)
      city_id.should be_kind_of Integer
    end
  end

  describe "#id_by_pref" do
    it "is cached in instance variable" do
      @client.instance_variable_get(:@id_by_pref).should be_nil
      @client.send(:id_by_pref)
      @client.instance_variable_get(:@id_by_pref).should be_kind_of Hash

      @client.should_not_receive(:pref_by_city)
      @client.send(:id_by_pref)
    end

    it "return table of id by pref" do
      @client.send(:id_by_pref).should be_kind_of Hash
    end
  end

  describe "#parse_area_table" do
    context "when passed malformed hash response" do
      it do
        expect {
          @client.send(:parse_area_table, {:unexpected => :hash})
        }.to raise_error(WeatherHacker::Client::ParseError)
      end
    end
  end
end
