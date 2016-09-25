require 'html_stripper/version'

# Main class for HtmlStripper.
class HtmlStripper
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

  def process_fragment(html)
    return html if html =~ @exclude_head_regex
    html = html.gsub(COMMENT_REGEX, '') if @options[:strip_comments]
    html = html.gsub(NEWLINE_REGEX, "\n") if @options[:simplify_lines]
    html = html.gsub(SPACES_REGEX, ' ') if @options[:minify_spaces]
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

require 'html_stripper/private_constants'
