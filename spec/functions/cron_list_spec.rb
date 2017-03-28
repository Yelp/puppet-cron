require 'spec_helper'

describe 'cron_list' do

  context 'args validation' do
    it {
      expect { subject.call([]) }.to raise_error(Puppet::ParseError)
      expect { subject.call([1]) }.to raise_error(Puppet::ParseError)
      expect { subject.call([1,2]) }.to raise_error(Puppet::ParseError)

      expect { subject.call([1,-2,3]) }.to raise_error(Puppet::ParseError)
      expect { subject.call([1.0,2,3]) }.to raise_error(Puppet::ParseError)
      expect { subject.call([3,2,1,]) }.to raise_error(Puppet::ParseError)
    }
  end

  context 'default' do
    it {
      should run.with_params(1,2,3).and_return('1')
      should run.with_params(10,60,10).and_return('0,10,20,30,40,50')
      should run.with_params(2,24,12).and_return('2,14')
      should run.with_params(3,60,15).and_return('3,18,33,48')
      should run.with_params(48,60,15).and_return('3,18,33,48')
    }
  end

end
