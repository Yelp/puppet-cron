module Puppet::Parser::Functions
  newfunction(:annotate, :type => :rvalue, :doc => <<-EOS
  Determines the location (file:line) of the declaration for the current
  resource.  Useful for creating links to documentation automaticall from
  Puppet code.

  Doesn't work with the 'include' function (e.g. include sshd) or
  (probably) resources created with create_resources.
  EOS
  ) do |args|
    'annotation:1'
  end
end
