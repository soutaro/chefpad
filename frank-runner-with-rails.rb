require "frank-cucumber/frank_helper"
require "minitest/unit"
require "active_support/test_case"
require "fileutils"

ENV["RAILS_ENV"] = "frank"

load "config/environment.rb"

class FrankTest < ActiveSupport::TestCase
  include Frank::Cucumber::FrankHelper

  def start_client
    system "rm -fr ~/Library/Application\\ Support/iPhone\\ Simulator/5.1/Applications/*"
    sleep 1
    FileUtils.cd "chef-pad-client" do
      system "frank launch"
    end
  end

  def stop_client
    quit_simulator
    sleep 1
    system "rm -fr ~/Library/Application\\ Support/iPhone\\ Simulator/5.1/Applications/*"
  end

  setup do
    # Start client running
    start_client
  end

  teardown do
    stop_client

    # Reset environment
    Account.destroy_all
    Recipe.destroy_all
  end
end

def start_rails
  system "rm -f db/frank.sqlite3 && rake db:migrate RAILS_ENV=frank"
  system "ps ax | grep rails | grep ruby | awk '{ print $1 }' | xargs kill -INT"
  system "rails server --daemon --environment=frank"

  if block_given?
    begin
      yield
    ensure
      stop_rails
    end
  end
end

def stop_rails
  system "cat tmp/pids/server.pid | xargs kill -INT"
end

start_rails do
  ARGV.each do |file|
    load file
  end

  MiniTest::Unit.new.run
end