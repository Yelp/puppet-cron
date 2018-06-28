require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec/core/shared_context'

RSpec.configure do |c|
  c.color = true
  c.profile_examples = true if $stdin.isatty && ENV['PROFILE']
  c.module_path = 'spec/fixtures/modules'
  c.manifest_dir = 'spec/fixtures/manifests'
end
