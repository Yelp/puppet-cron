module Puppet::Parser::Functions
  newfunction(:cron_list, :type => :rvalue, :doc => <<-EOD
    Builds a custom list of numbers for crontab.
    Takes 3 args - start, end, step. Start must be non-negative integer,
    end and step must be positive integers.

    # run twice a day starting with hour 2 every 12 hours;
    # will return '2,14'
    cron::d { 'test1':
      hour => cron_list(2, 24, 12),
      ...
    }

    # run every 5 minutes starting with random minute;
    # will return something like '3,8,13,18,23,28,33,38,43,48,53,58'
    cron::d { 'test2':
      minute => cron_list(fqdn_rand(60, 'starting minute for test2'), 60, 5),
      ...
    }
    EOD
  ) do |args|
    raise(Puppet::ParseError, 'expected 3 args: start, end, step') if args.size != 3
    raise(Puppet::ParseError, 'all arguments must be integers') if args.any? {|x| !x.is_a?(Fixnum) }

    _start, _end, _step = args
    raise(Puppet::ParseError, 'start must be non-negative integer') if _start < 0
    raise(Puppet::ParseError, 'end and step args must be positive integers') if _end <= 0 || _step <= 0
    raise(Puppet::ParseError, 'start arg must be less than end arg') if _start >= _end

    (0..(_end/_step).to_i).map { |x|
      ( _start + x * _step ) % _end }.uniq.sort.join(',')
  end
end
