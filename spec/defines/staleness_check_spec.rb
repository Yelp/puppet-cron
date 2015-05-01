require 'spec_helper'

describe 'cron::staleness_check' do
  let(:title) { 'cron_foobar' }

  context 'with 10m interval' do
    let(:params) {{
      :threshold => '10m',
      :params => { 'team' => 'baz', 'runbook' => 'y/rb-foobar' },
      :user => 'mary',
    }}

    it {
      should contain_monitoring_check('cron_foobar_staleness') \
        .with_check_every('120') \
        .with_command(/600$/)
    }
  end

  context 'with long interval' do
    let(:params) {{
      :threshold => '240h',
      :params => { 'team' => 'ops', 'runbook' => 'y/rb-backups' },
      :user => 'bob',
    }}

    it "should never have an interval over an hour" do 
      should contain_monitoring_check('cron_foobar_staleness') \
        .with_check_every('3600')
		end
  end

  context 'without runbook link' do
    let(:params) {{
      :threshold => '10m',
      :params => { 'team' => 'baz', },
      :user => 'mary',
    }}
    it {
      should contain_monitoring_check('cron_foobar_staleness') \
        .with_check_every('120') \
    }
  end

  context 'creates success wrapper' do
    let(:params) {{
      :threshold => '10m',
      :params => { 'team' => 'baz', },
      :user => 'mary',
    }}
    it {
      should contain_file('/nail/run/success_wrapper/cron_foobar') \
        .with_owner('mary') \
        .with_group(nil) \
    }
  end
end
