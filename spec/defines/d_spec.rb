require 'spec_helper'

describe 'cron::d' do
  let(:title) { 'foobar' }
  let(:facts) {{
    :operatingsystemrelease => '14.04'
  }}
  let(:pre_condition) { "class { 'cron': }" }
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
    /^37 \* \* \* \* somebody \(foobar/m
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

  context 'with staleness and colon in the name' do
    let(:params) {{
      :minute    => 37,
      :user      => 'somebody',
      :command   => 'foobar | logger -t cleanup-srv-deploy -p daemon.info',
      :staleness_threshold => '10m',
      :staleness_check_params => {},
    }}
    let(:title) { 'something:latest:foo' }

    it {
      should contain_file('/nail/etc/cron.d/something_latest_foo') \
        .with_content(/success_wrapper 'cron_something_latest_foo'/)
      should contain_cron__staleness_check('cron_something_latest_foo')
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
        .with_content(/0 \* \* \* \* somebody \(flock -n "\/var\/lock\/cron_foobar\.lock" overrunning command\) 2>&1 \| logger -t cron_foobar \n/)
    }
  end

  context 'when asked to timeout' do
    let(:params) {{
      :minute    => 0,
      :user      => 'somebody',
      :command   => 'overrunning command',
      :timeout   => '123s',
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(/0 \* \* \* \* somebody \(\/nail\/sys\/bin\/yelp_timeout -s 9 123s overrunning command\) 2>&1 \| logger -t cron_foobar \n/)
    }
  end

  context 'when asked to timeout without syslog' do
    let(:params) {{
      :minute    => 0,
      :user      => 'somebody',
      :command   => 'overrunning command',
      :timeout   => '123s',
      :log_to_syslog => false,
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(/0 \* \* \* \* somebody \(\/nail\/sys\/bin\/yelp_timeout -s 9 123s overrunning command\)\n/)
    }
  end


  context 'with second as */10' do
    let(:params) {{
      :minute           => '*',
      :command          => 'echo hi',
      :user             => 'nobody',
      :second           => '*/10',
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(%r{
          \*\ \*\ \*\ \*\ \*\ nobody\ \(echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 10;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 20;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 30;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 40;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 50;\ echo\ hi\).*\Z
        }x)
    }
  end

  context 'with multiple seconds and locking and timeout' do
    let(:params) {{
      :minute           => '*',
      :command          => 'echo hi',
      :user             => 'nobody',
      :second           => '*/20',
      :lock             => true,
      :timeout          => '2h',
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(%r{
          \*\ \*\ \*\ \*\ \*\ nobody\ \(flock\ -n\ "/var/lock/cron_foobar.lock"\ \/nail\/sys\/bin\/yelp_timeout\ -s\ 9\ 2h\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 20;\ flock\ -n\ "/var/lock/cron_foobar.lock"\ \/nail\/sys\/bin\/yelp_timeout\ -s\ 9\ 2h\  echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 40;\ flock\ -n\ "/var/lock/cron_foobar.lock"\ \/nail\/sys\/bin\/yelp_timeout\ -s\ 9\ 2h\ echo\ hi\).*\n
        }x)
    }
  end

  context 'with complex seconds' do
    let(:params) {{
      :minute           => '*',
      :command          => 'echo hi',
      :user             => 'nobody',
      :second           => '*/30,8,40-50/2',
    }}

    it {
      should contain_file('/nail/etc/cron.d/foobar') \
        .with_content(%r{
          \*\ \*\ \*\ \*\ \*\ nobody\ \(echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 8;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 30;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 40;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 42;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 44;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 46;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 48;\ echo\ hi\).*\n
          \*\ \*\ \*\ \*\ \*\ nobody\ \(sleep\ 50;\ echo\ hi\).*\n
        }x)
    }
  end
end
