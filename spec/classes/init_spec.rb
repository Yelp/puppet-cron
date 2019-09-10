require 'spec_helper'

describe 'cron' do

  context 'by default' do
   let(:facts) {{
     :lsbdistid => 'Ubuntu',
     :lsbdistrelease => '14.04',
     :operatingsystemrelease => '14.04',
     :osfamily => 'Debian',
   }}
   it { should compile }
   it { should contain_file('/nail/sys/bin/cron_staleness_check') }
  end

  context 'with service ensure stopped' do
    let(:facts) {{
      :lsbdistid => 'Ubuntu',
      :lsbdistrelease => '16.04',
      :operatingsystemrelease => '16.04',
      :osfamily => 'Debian',
    }}
    let(:params) {{
      :service_ensure => 'stopped'
    }}
    it { should compile }
    it { should contain_service('cron').with_ensure('stopped') }
  end

end
