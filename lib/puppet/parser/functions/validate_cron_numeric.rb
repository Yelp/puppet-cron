module Puppet::Parser::Functions

  newfunction(:validate_cron_numeric, :doc => <<-'ENDHEREDOC') do |args|
    Validate that all passed values are valid cron time strings. Abort catalog
    compilation if any value fails this check.

    The following values will pass:

        $example1 = "1"
        $example2 = "*"
        $example3 = "5-55/5"
        $example5 = "24,29"
        $example6 = "*/6"
        validate_cron_numeric($example1)
        validate_cron_numeric($example2)
        validate_cron_numeric($example3)
        validate_cron_numeric($example4)
        validate_cron_numeric($example5)
        validate_cron_numeric($example6)

    The following values will fail, causing compilation to abort:

        validate_cron_numeric(true)
        validate_cron_numeric([ 'some', 'array' ])
        $undefined = undef
        validate_cron_numeric($undefined)
        validate_cron_numeric("foo")

    ENDHEREDOC

    unless args.length == 1 then
      raise Puppet::ParseError, ("validate_cron_numeric(): wrong number of arguments (#{args.length}; must be 1)")
    end
    arg = args[0]
    unless arg.respond_to?('split') then
        raise Puppet::ParseError, ("#{arg.inspect} is not a cron time string. It looks to be a #{arg.class}")
    end

    arg.split(/[\/,-]/).each do |arg|
      if arg != '*' && ( !arg.respond_to?(:to_i) || !arg.to_i.is_a?(Integer) || arg.to_i.to_s != arg.to_s )
        raise Puppet::ParseError, ("#{arg.inspect} is not a cron time string.  It looks to be a #{arg.class}")
      end
    end

  end

end
