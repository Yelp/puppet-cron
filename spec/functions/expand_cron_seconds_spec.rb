require 'spec_helper'

describe 'expand_cron_seconds' do

  context "stuff" do
    it { should run.with_params('*').and_return((0..59).step().to_a) }
    it { should run.with_params('*/30').and_return([0, 30]) }
    it { should run.with_params('1,10,30-40/2').and_return([1,10,30,32,34,36,38,40]) }
    it { should run.with_params('2,1').and_return([1,2]) }
    it { should run.with_params('*/35,*/23').and_return([0,23,35,46]) }
  end
end
