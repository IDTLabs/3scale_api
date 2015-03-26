require 'spec_helper'

describe ThreescaleApi do

  it "should rock" do
    lambda do
      Threescale::API.new
    end.should raise_error
  end

end