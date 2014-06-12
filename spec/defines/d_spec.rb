require 'spec_helper'

describe 'cron::d' do
  let(:title) { 'foobar' }
  let(:params) {{
    :minute  => 37,
    :user    => 'somebody',
    :command => 'foobar | logger -t cleanup-srv-deploy -p daemon.info',
  }}

  it {
    should contain_file('/etc/cron.d/foobar').with_ensure('link') \
      .with_target('/nail/etc/cron.d/foobar')
    should contain_file('/nail/etc/cron.d/foobar').with_ensure('file')
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


  context 'with staleness' do
    let(:params) {{
      :minute    => 37,
      :user      => 'somebody',
      :command   => 'foobar | logger -t cleanup-srv-deploy -p daemon.info',
      :staleness_threshold => '10m',
      :staleness_check_params => { 'team' => 'baz' },
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(/success_wrapper/)

      should contain_monitoring_check('cron_foobar_freshness') \
        .with_check_every('120') \
        .with_command(/600$/)
    }
  end
end
