require 'spec_helper'

describe 'cron::d' do
  let(:title) { 'foobar' }
  let(:params) {{
    :minute  => 37,
    :user    => 'somebody',
    :command => 'foobar | logger -t cleanup-srv-deploy -p daemon.info',
  }}

  it {
    should contain_exec('Symlink /nail/etc/cron.d/foobar at /etc/cron.d/foobar') \
      .with_command("ln -nsf '/nail/etc/cron.d/foobar' '/etc/cron.d/foobar'")
    should contain_file('/nail/etc/cron.d/foobar').with_ensure('file')

    should_not contain_cron__staleness_check
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
      :staleness_check_params => { 'runbook' => 'y/rb-foobar' },
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(/success_wrapper 'cron_foobar'/)
      should contain_cron__staleness_check('cron_foobar')
    }
  end

  context 'when asked to lock' do
    let(:params) {{
      :minute    => 0,
      :user      => 'somebody',
      :command   => 'overrunning command',
      :lock      => true,
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(/0 \* \* \* \* somebody flock -n \/var\/lock\/cron_foobar\.lock overrunning command 2>&1 \| logger -t cron_foobar \n/)
    }
  end

end
