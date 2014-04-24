# # Management of vendor/ code in the yelp puppet codebase.
#
# Specficially, management of rubygems and puppetforge modules
#
# # TL;DR
#
# Using software with a sane (Apache2/MIT/BSD/GPL/Python/Perl/Ruby)
# license with bundler or librarian-puppet is cool (just go to it).
# For contributing back, other licenses or if you want to inline,
# external code which isn't a puppetforge or rubygems module, submit
# the legal form and/or see below for further guidance.
#
# # Legal form
#
# * https://docs.google.com/a/yelp.com/forms/d/1sePh0oZGNqpxnxt3_C2eRHIseJWMvgH7smqzbSsDQ9o/viewform
#
# # Licenses
#
# Full list of open source licenses you can use can be found at:
#
# https://trac.yelpcorp.com/wiki/LegalInfo
#
# These can be broadly classified into open:
# - Apache2
# - BSD (2 or 3 clause)/MIT
# - GPL2/3 (given no redistribution happens)
# Restrictive:
# - Ruby
# Discuss:
# - AGPL (Affero)
# - Anything not in the list!
#
# Open or restrictive licenses are ok to use.
# Restrictive licences need changes to be made public (see 'Contributing back')
# Discuss licenses - you _must_ discuss / disclose use of software, or
#                    contributing back (even trivial patches).
#
# Please also refer to the list of licenses here: http://opensource.org/licenses
# when giving legal a heads up, as this will help them to make a decision quickly!
#
# # Contributing back
#
# Trivial patches (e.g. failing test, doc tweak, small additional option)
# for 'open' or 'restrictive' software can be done under your personal
# github account, without notification, with you being the nominated copyright holder.
#
# For 'restrictive' licenses, you _MUST_ publish your changes.
#
# Less trivial contributions (anything that is worth forking into Yelp's
# official github, or anything you'd talk up to recruitment candidates)
# should be initially done in an internal repsoitory whilst notifying legal.
#
# We can then fork the repository into the official yelp github repository,
# and you can push your changes there.
#
# If you're proposing to pull code previously written at Yelp and committed
# to the normal (non vendor/) part of the codebase out into open source
# code (even if as an addition to a pre-existing project) then you
# must get a thumbs up from your manager or legal first.
#
# If in doubt, speak to your manager, or use the form for legal guidance!
#
# Upgrades
#
# When upgrading packages which are inlined, you _MUST_ check that the license
# conditions have not been changed in the upgraded version. Compare the
# license noted in the comment beside the package
#

# # IMPORTANT!
#
# PLEASE make sure to look up the license, and commit a comment about which
#        licence is in use when you add something here
# PLEASE make sure to verify the license conditions have not changed for
#        anything here which you upgrade

source 'https://rubygems.org'

gem 'puppet-syntax', '1.2.0'                        # MIT
gem 'diff-lcs', '1.2.4'                    # MIT/GPL2/Perl
gem 'json', '1.8.0'                        # Ruby
gem 'r10k', '1.1.3'                        # Apache2
gem 'metaclass', '0.0.1'                   # MIT
gem 'mocha', '0.14.0'                      # MIT
gem 'puppetlabs_spec_helper', '0.4.1'      # Apache2
gem 'puppet-lint', #'~> 0.4.0.pre1'         # MIT
    :git => 'git://github.com/rodjek/puppet-lint.git' # Due to https://github.com/rodjek/puppet-lint/issues/224 - go back to forge as soon as there is a release
gem 'rake', '10.1.0'                       # MIT
gem 'rake-hooks', '1.2.3'                  # MIT
gem 'rspec', '2.14.1'                      # MIT
gem 'rspec-core', '2.14.5'                 # MIT
gem 'rspec-expectations', '2.14.5'         # MIT
gem 'rspec-mocks', '2.14.6'                # MIT
#gem 'rspec-puppet', '1.0.1'               # MIT
# Upgrade when 1.0.2 is out
gem 'rspec-puppet',
  :git => 'https://github.com/rodjek/rspec-puppet.git',
  :ref => '03e94422fb9bbdd950d5a0bec6ead5d76e06616b'

gem 'puppet', '~> 3.4.0'                     # Apache2
gem 'facter', '1.7.3'                      # Apache2
gem 'sensu-plugin'
gem 'hiera-puppet-helper',
  :git => 'git://github.com/bobtfish/hiera-puppet-helper.git',
  :ref => 'b3738f72b202cdee5e77f6cbf58235406cba0fa2'

