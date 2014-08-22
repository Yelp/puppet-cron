require 'spec_helper'

describe 'cron::staleness_check' do
  let(:title) { 'cron_foobar' }
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
end
