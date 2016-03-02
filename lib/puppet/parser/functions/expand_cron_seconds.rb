module Puppet::Parser::Functions
  newfunction(:expand_cron_seconds) do |args|
    unless args.length == 1 then
      raise Puppet::ParseError, ("expand_cron_seconds(): wrong number of arguments(#{args.length}; must be 1)")
    end

    arg = args[0].to_s

    times = []

    arg.split(/,/).each do |chunk|
      pattern = %r{
        # I want to use named capture groups, but ruby 1.8 doesnt support them.
        ^
          # single number
          (\d+)
        $
        |
        ^
          (
            # range
            \*
            |
            (\d+)-(\d+)
          )
          (?:
            # optional step
            /
            (
              \d+
            )
          )?
        $
      }x

      m = pattern.match(chunk)
      if not m then
        raise Puppet::ParseError, ("#{chunk.inspect} doesn't look like a valid cron time string.")
      end
      m_single = m[1]
      m_range = m[2]
      m_rangebegin = m[3]
      m_rangeend = m[4]
      m_step = m[5]

      if m_single then
        times.push(m_single.to_i)
      elsif m_range
        if m_range == '*' then
          range = (0...60)
        else
          range = (m_rangebegin.to_i .. m_rangeend.to_i)
        end
        step = m_step ? m_step.to_i : 1
        times.concat(range.step(step).to_a)
      else
        raise Puppet::ParseError, ("")
      end
    end

    return times.sort.uniq.to_a
  end
end
