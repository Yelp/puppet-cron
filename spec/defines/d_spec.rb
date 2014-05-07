require 'spec_helper'

describe 'cron::d' do
  let(:title) { 'foobar' }
  let(:params) {{
    :minute  => 37,
    :user    => 'somebody',
    :command => 'foobar | logger -t cleanup-srv-deploy -p daemon.info'
  }}

  it {
    should contain_file('/etc/cron.d/foobar')
  }

  [
    /MAILTO=""/,
    /^37 \* \* \* \* somebody foobar/m
  ].each do |regex|
    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(regex)
    }
  end
end
