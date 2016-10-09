require 'html_stripper/private_constants'

class HtmlStripper
  # parse texts between tags
  module InterTag
    include PrivateConstants

    DEFAULT_INTER_TAGS = IceNine.deep_freeze(
      comment: [COMMENT_REGEX, nil],
      doctype: [DOCTYPE_REGEX, nil],
      string: [/#{OUTSIDE_CHARACTER}++/, nil],
      newlines: [NEWLINES_REGEX, nil],
      spaces: [SPACES_REGEX, nil],
      close_tag: [%r{</#{OUTSIDE_CHARACTER}++#{SPACE_CHARACTER}*>}, nil],
      inside_tag: [/<#{OUTSIDE_CHARACTER}++/, :inside_tag],
      last_resort: [/./m, nil]
    )

    INTER_TAG_OPTIONS = IceNine.deep_freeze(
      strip_comments: [:comment, ''],
      simplify_lines: [:newlines, "\n"],
      minify_spaces: [:spaces, ' ']
    )

    private

    def initialize_inter_tags
      @inter_tags = Hash[
        @keep_patterns.map.with_index { |regex, i| [:"keep_#{i}", [regex, nil]] }
      ]
      @inter_tags.merge!(Marshal.load(Marshal.dump(DEFAULT_INTER_TAGS)))
      INTER_TAG_OPTIONS.each do |option_key, (table_key, val)|
        next unless @options[option_key]
        @inter_tags[table_key][1] = val
      end
    end

    def inter_tag
      output = ''.dup
      until @scanner.eos?
        @inter_tags.each_value do |(regex, action)|
          next unless (s = @scanner.scan(regex))
          output << dispatch_inter_tag(action, s)
          break
        end
      end
      output
    end

    def dispatch_inter_tag(action, str)
      case action
      when nil then str
      when String then action
      when Symbol then __send__(action, str)
      end
    end
  end
end
