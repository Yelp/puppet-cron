require 'spec_helper'

describe 'cron::file' do
  let(:params) {{
    :file_params  => {},
  }}

  context 'with a full path' do
    let(:title) { '/etc/cron.d/foobar' }

    it { should raise_error(Puppet::Error) }
  end
end
