require 'spec_helper'

describe 'validate_cron_numeric' do
  it 'should fail with foo' do
    expect { subject.call(['foo']) }.to raise_error(Puppet::ParseError)
  end
  it 'should fail with empry array' do
    expect { subject.call([[]]) }.to raise_error(Puppet::ParseError)
  end
  it 'should fail if given multiple values' do
    expect { subject.call(['1', '2']) }.to raise_error(Puppet::ParseError)
  end
  it 'works for 1' do
    expect { subject.call(['1']) }.not_to raise_error()
  end
  it 'works for *' do
    expect { subject.call(['*']) }.not_to raise_error()
  end
  it 'works for 1.to_s' do
    expect { subject.call([1.to_s]) }.not_to raise_error()
  end
  it 'works for 10,35,50' do
    expect { subject.call(['10,35,50']) }.not_to raise_error()
  end
  it 'works for */5' do
    expect { subject.call(['*/5']) }.not_to raise_error()
  end
  it 'works for 5-55/5' do
    expect { subject.call(['5-55/5']) }.not_to raise_error()
  end
end
