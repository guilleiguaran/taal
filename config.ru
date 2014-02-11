$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "lib"))
require "simple_builder"

run SimpleBuilder::App.new
