module Puppet::Parser::Functions
  newfunction(:cron_list, :type => :rvalue, :doc => <<-EOD
    Builds a custom list of numbers for crontab.
    Takes 3 args - start, end, step

    # run twice a day starting with hour 2 every 12 hours;
    # will return '2,14'
    cron::d { 'test1':
      hour => cron_list(2, 24, 12),
      ...
    }

    # run every 5 minutes starting with random minute;
    # will return something like '3,8,13,18,23,28,33,38,43,48,53,58'
    cron::d { 'test2':
      minute => cron_list(fdqn_rand(60, 'starting minute for test2'), 60, 5),
      ...
    }
    EOD
  ) do |args|
    raise(Puppet::ParseError, 'expected 3 args: start, end, step') if args.size != 3
    raise(Puppet::ParseError, 'all args must be positive integers') if
      args.reject { |x| x.is_a?(Fixnum) && x > 0 }.any?
    _start, _end, _step = args
    raise(Puppet::ParseError, 'start arg must be less than end arg') if _start >= _end

    (0..(_end/_step).to_i).map { |x|
      ( _start + x * _step ) % _end }.uniq.sort.join(',')
  end
end
