require 'html_stripper/version'

# Main class for HtmlStripper.
class HtmlStripper
  # load after class was created, before using constants
  require 'html_stripper/private_constants'

  CDATA_REGEXES = [/<!\[CDATA\[/i, /\]\]>/].freeze

  COND_COMMENT_REGEXES = [/<!--<!\[|<!--\[/, /\]-->/].freeze

  DEFAULT_OPTIONS = {
    strip_comments: true,
    simplify_lines: true,
    minify_spaces: true,
    keep_tags: [:script, :style, :textarea, :pre].freeze,
    keep_patterns: [CDATA_REGEXES, COND_COMMENT_REGEXES].freeze
  }.freeze

  # Generates HtmlStripper.
  # @param  [Hash] opts the options for stripping.
  # @option opts [true, false] :strip_comments
  #  whether to strip comments.
  # @option opts [true, false] :simplify_lines
  #  whether to strip comments.
  def initialize(opts = {})
    @options = DEFAULT_OPTIONS.merge(opts)
    @options[:keep_patterns] = @options[:keep_patterns].map do |row|
      row.map do |item|
        item.is_a?(String) ? Regexp.escape(item) : item
      end
    end
    build_regexes
  end

  # strip from specified HTML.
  # @param [String] html input HTML.
  # @return [String] return stripped HTML.
  def run(html)
    splitted = html.split @split_regex
    splitted.map { |frag| process_fragment frag }.join
  end

  # strip from specified HTML.
  # @param [String] html input HTML.
  # @param [Hash] opts the options for stripping (same for .new).
  def self.run(html, opts = {})
    new(opts).run(html)
  end

  private

  SUBSTITUTIONS = {
    strip_comments: [COMMENT_REGEX, ''],
    simplify_lines: [NEWLINE_REGEX, "\n"],
    minify_spaces: [SPACES_REGEX, ' ']
  }.freeze

  def process_fragment(html)
    return html if html =~ @exclude_head_regex
    SUBSTITUTIONS.each do |key, (pattern, sub)|
      html = html.gsub(pattern, sub) if @options[key]
    end
    html
  end

  def build_tag_regexes
    @tag_regexes = @options[:keep_tags].map do |sym|
      escaped = Regexp.escape sym.to_s
      [/<#{escaped}#{TAGNAME_END_REGEX}/i, %r{</#{escaped}>}i]
    end
  end

  def build_regexes
    build_tag_regexes
    patterns = @tag_regexes + @options[:keep_patterns]
    if patterns.empty?
      @exclude_head_regex = @split_regex = NO_HIT_REGEX
      return
    end
    @exclude_head_regex =
      /\A#{patterns.map { |item| item[0] }.join('|')}/mi
    @split_regex =
      /#{patterns.map { |item| "(#{item[0]}.*?#{item[1]})" }.join('|')}/mi
  end
end
