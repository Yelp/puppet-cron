require 'spec_helper'

describe 'cron' do

  context 'by default' do
   let(:facts) {{
     :lsbdistid => 'Ubuntu',
     :operatingsystemrelease => '14.04',
     :osfamily => 'Debian',
   }}
   it { should compile }
   it { should contain_file('/nail/sys/bin/cron_staleness_check') }
  end

end
