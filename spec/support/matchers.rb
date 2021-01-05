require 'rspec/expectations'

RSpec::Matchers.define :a_class_extending do |expected|
  match { |actual| actual.singleton_class < expected }

  description { "a class extending #{expected}" }

  failure_message { |actual| "expected that #{actual} would extend #{expected}" }
end
