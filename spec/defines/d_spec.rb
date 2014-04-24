require 'spec_helper'

describe 'cron::d' do
  let(:title) { 'cleanup-srv-deploy' }
  let(:params) {{
    :minute  => 37,
    :user    => 'push',
    :command => '/nail/sys/srv-deploy/cleanup-deploy-versions 8 | logger -t cleanup-srv-deploy -p daemon.info'
  }}
  [
    /MAILTO=""/,
    /^37 \* \* \* \* push \/nail\/sys\/srv-deploy\/cleanup-dep/m
  ].each do |regex|
    it {
      should contain_file('/etc/cron.d/cleanup-srv-deploy') \
        .with_content(regex)
    }
  end
end
