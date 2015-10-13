require 'spec_helper'

describe 'cron' do

  let(:facts) {{
    :operatingsystemrelease => '14.04'
  }}

  context 'by default' do
    it { should compile }
    it { should_not contain_file('/etc/cron.d') }
    it { should contain_file('/nail/sys/bin/cron_staleness_check') }
  end

  context 'when asked to purge cron.d' do
    let(:params) {{ :purge_cron_d => true }}
    it { should compile }
    it { should contain_file('/etc/cron.d').with_purge(true) }
  end

end
