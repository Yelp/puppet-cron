require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec/core/shared_context'

module Puppet4Helper
  extend RSpec::Core::SharedContext

  def site_pp
    [(File.read('spec/fixtures/manifests/site.pp') rescue '')]
  end

  let(:pre_condition) { site_pp }
end

RSpec.configure do |c|
  c.include Puppet4Helper if Puppet.version >= '4' || ENV['FUTURE_PARSER']
  c.color = true
  c.profile_examples = true if $stdin.isatty && ENV['PROFILE']
  c.module_path = 'spec/fixtures/modules'
  c.manifest_dir = 'spec/fixtures/manifests'
end
