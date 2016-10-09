require 'ice_nine'

class HtmlStripper # :nodoc:
  # Definitions of constants internally used by HtmlStripper.
  # Do not use from outside.
  module PrivateConstants
    COMMENT_REGEX = /<!--.*?-->/m

    TAGNAME_END_REGEX = %r{[\s\/>]}

    NO_HIT_REGEX = /(?!)/

    # from HTML5 specification 2.4.1
    SPACE_CHARACTER = /[ \t\r\n\f]/
    OUTSIDE_CHARACTER = /[^ \t\r\n\f<>]/

    # from HTML5 specification 8.1.2.3
    ATTRIBUTE_NAME_REGEX = %r{(?>[^\x00'">/= \t\r\n\f]+)}
    UNQUOTED_VALUE_REGEX = /(?>[^ \t\r\n\f"'=<>`]+)/
    QUOTED_VALUE_REGEX = /'.*?'|".*?"/m
    KEY_VAL_REGEX = /
      (#{ATTRIBUTE_NAME_REGEX})
      #{SPACE_CHARACTER}*=#{SPACE_CHARACTER}*
      (#{QUOTED_VALUE_REGEX}|#{UNQUOTED_VALUE_REGEX})
    /mx

    DOCTYPE_REGEX = /<!DOCTYPE#{TAGNAME_END_REGEX}.*?>/m

    NEWLINES_REGEX = /#{SPACE_CHARACTER}*[\r\n\f]#{SPACE_CHARACTER}++/

    SPACES_REGEX = /([ \t])[ \t]++/

    private_constant(*constants(false))
  end

  include PrivateConstants
end
