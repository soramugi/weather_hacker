require "spec_helper"

describe "WeatherHacker::Client" do
  before do
    @client = WeatherHacker::Client.new
  end

  describe "#get_weather" do
    before(:all) do
      @zipcode = "690-0261"
    end

    it "get parsed weather data in Hash" do
      hash = @client.get_weather(@zipcode)
      [Hash, NilClass].should be_include hash.class
    end
  end

  describe "#update_area_table" do
    it "has not table at first" do
      @client.instance_variable_get(:@id_by_city).should be_nil
      @client.instance_variable_get(:@pref_by_city).should be_nil
    end

    it "has area table after call" do
      @client.update_area_table
      @client.send(:id_by_city).keys.size.should_not == 0
      @client.send(:pref_by_city).keys.size.should_not == 0
    end
  end

  describe "#city_id_by_zipcode" do
    it "return city_id" do
      city_id = @client.city_id_by_zipcode("108-0071")
      city_id.should be_kind_of Integer
    end
  end
end
