class HtmlStripper # :nodoc:
  # Definitions of constants internally used by HtmlStripper.
  # Do not use from outside.
  module PrivateConstants
    COMMENT_REGEX = /<!--.*?-->/m

    TAGNAME_END_REGEX = %r{[\s\/>]}

    NO_HIT_REGEX = /(?!)/

    # from HTML5 specification 2.4.1
    SPACE_CHARACTER = /[ \t\r\n\f]/

    # from HTML5 specification 8.1.2.3
    ATTRIBUTE_NAME_REGEX = %r{(?>[^\x00'">/= \t\r\n\f]+)}
    UNQUOTED_VALUE_REGEX = /(?>[ \t\r\n\f"'=<>`]+)/
    QUOTED_VALUE_REGEX = /'.*?'|".*?"/m

    OUTSIDE_TAG = /(?=[^><]*+(?:<|\z))/m

    NEWLINE_REGEX = /#{SPACE_CHARACTER}*[\r\n\f]#{SPACE_CHARACTER}+#{OUTSIDE_TAG}/

    SPACES_REGEX = /(?>[ \t]{2,})#{OUTSIDE_TAG}/

    private_constant(*constants(false))
  end

  include PrivateConstants
end
