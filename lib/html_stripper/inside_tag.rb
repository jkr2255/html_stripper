require 'html_stripper/private_constants'

class HtmlStripper
  # parse texts inside tags
  module InsideTag
    include PrivateConstants

    DEFAULT_INSIDE_TAG = IceNine.deep_freeze(
      key_value: [KEY_VAL_REGEX, nil],
      newlines: [NEWLINES_REGEX, nil],
      spaces: [SPACES_REGEX, nil],
      value: [UNQUOTED_VALUE_REGEX, nil],
      self_close: [%r{/>}, :throw],
      close: [/>/, :throw],
      last_resort: [/./m, nil]
    )

    INSIDE_TAG_OPTIONS = IceNine.deep_freeze(
      simplify_lines: [:newlines, "\n"],
      minify_spaces_inside_tags: [:spaces, ' ']
    )

    private

    def initialize_inside_tag
      @inside_tag = Marshal.load(Marshal.dump(DEFAULT_INSIDE_TAG))
      INSIDE_TAG_OPTIONS.each do |option_key, (table_key, val)|
        next unless @options[option_key]
        @inside_tag[table_key][1] = val
      end
    end

    def inside_tag_main
      @inside_tag.each_value do |(regex, action)|
        next unless (s = @scanner.scan(regex))
        return dispatch_inside_tag(action, s)
      end
    end

    def inside_tag(str)
      output = str.dup
      last_val = catch :end_tag do
        loop do
          throw :end_tag if @scanner.eos?
          output << inside_tag_main
        end
      end
      output + last_val.to_s
    end

    def dispatch_inside_tag(action, str)
      case action
      when nil then str
      when String then action
      when :throw then throw :end_tag, str
      end
    end
  end
end
