module Puppet::Parser::Functions
  newfunction(
    :human_time_to_seconds,
    :type => :rvalue,
    :doc => <<-'ENDHEREDOC') do |args|
Converts a human time of the form Xs, Xm or Xh into an integer number of seconds
ENDHEREDOC
    if !(arg = args.first) || args.size > 1
      raise HumanTimeError, "wrong number of arguments (#{args.length}; must be 1)"
    end

    unless arg.respond_to? 'to_s'
      raise HumanTimeError, "#{arg.class}(#{arg.inspect}) does not respond to #to_s"
    end

    unless arg.to_s =~ /^(\d+)([hmsdw])?$/
      raise HumanTimeError, "#{arg} is not of the form \\d+([hmsdw])?"
    end

    mult = {nil => 1, 's' => 1, 'm' => 60, 'h' => 3600, 'd' => 86400, 'w' => 604800 }[$2]
    time = $1.to_i * mult
    time.to_s
  end

  class HumanTimeError < Puppet::ParseError; end
end
