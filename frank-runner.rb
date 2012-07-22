require "frank-cucumber/frank_helper"
require "minitest/unit"
require "active_support/test_case"

class FrankTest < ActiveSupport::TestCase
  include Frank::Cucumber::FrankHelper
end

ARGV.each do |file|
  load file
end

MiniTest::Unit.new.run
