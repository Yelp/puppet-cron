require 'spec_helper'

describe 'cron::file' do
  let(:params) {{
    :file_params => {}
  }}
  let(:facts) {{
    :operatingsystemrelease => '14.04',
    :lsbdistid => 'Ubuntu',
    :osfamily => 'Debian',
    :lsbdistrelease => '14.04',
  }}
  let(:pre_condition) { "class { 'cron': }" }

  context 'with correct title' do
    let(:title) { 'foobar' }

    it { should_not raise_error }
  end

  context 'with a full path' do
    let(:title) { '/etc/cron.d/foobar' }

    it { should raise_error(/validate/) }
  end

  context 'with a dot' do
    let(:title) { 'foo.bar' }

    it { should raise_error(/validate/) }
  end
end
