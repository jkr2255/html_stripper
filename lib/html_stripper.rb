require 'html_stripper/version'
require 'html_stripper/private_constants'
require 'html_stripper/inter_tag'
require 'html_stripper/inside_tag'
require 'strscan'

# Main class for HtmlStripper.
class HtmlStripper
  CDATA_REGEXES = [/<!\[CDATA\[/i, /\]\]>/].freeze

  COND_COMMENT_REGEXES = [/<!--<!\[|<!--\[/, /\]-->/].freeze

  DEFAULT_OPTIONS = IceNine.deep_freeze(
    strip_comments: true,
    simplify_lines: true,
    minify_spaces: true,
    minify_spaces_inside_tags: true,
    keep_tags: [:script, :style, :textarea, :pre],
    keep_patterns: [CDATA_REGEXES, COND_COMMENT_REGEXES]
  )

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
    initialize_tables
  end

  # strip from specified HTML.
  # @param [String] html input HTML.
  # @return [String] return stripped HTML.
  def run(html)
    @scanner = StringScanner.new(html)
    inter_tag
  end

  # strip from specified HTML.
  # @param [String] html input HTML.
  # @param [Hash] opts the options for stripping (same for .new).
  def self.run(html, opts = {})
    new(opts).run(html)
  end

  private

  include InterTag
  include InsideTag

  def initialize_tables
    initialize_inter_tags
    initialize_inside_tag
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
    @keep_patterns = patterns.map { |item| /#{item[0]}.*?#{item[1]}/mi }
  end
end
