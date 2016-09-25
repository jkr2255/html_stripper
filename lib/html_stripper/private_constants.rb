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
    IN_TAG_OUT_VALUE = %r{
      (?=
        (?:#{SPACE_CHARACTER}*+
          #{ATTRIBUTE_NAME_REGEX}
          (
            #{SPACE_CHARACTER}*+
            =#{SPACE_CHARACTER}*+
            (?:#{UNQUOTED_VALUE_REGEX}|#{QUOTED_VALUE_REGEX})
          )?
        )*
        #{SPACE_CHARACTER}*+/?>
      )
    }x

    INSIDE_TAG_SPACES_REGEX = /(?>#{SPACE_CHARACTER}{2,})#{IN_TAG_OUT_VALUE}/

    OUTSIDE_TAG = /(?=[^><]*+(?:<|\z))/m

    NEWLINE_REGEX = /#{SPACE_CHARACTER}*[\r\n\f]#{SPACE_CHARACTER}++#{OUTSIDE_TAG}/

    SPACES_REGEX = /(?>[ \t]{2,})#{OUTSIDE_TAG}/

    private_constant(*constants(false))
  end

  include PrivateConstants
end
