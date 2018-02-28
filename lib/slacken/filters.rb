module Slacken
  module Filters
  end
end

require 'slacken/filter'

require 'slacken/filters/elim_blanks'
require 'slacken/filters/elim_invalid_links'
require 'slacken/filters/elim_line_breaks'
require 'slacken/filters/extract_img_alt'
require 'slacken/filters/group_inlines'
require 'slacken/filters/group_indent'
require 'slacken/filters/replace_unsupported_imgs'
require 'slacken/filters/sanitize_headline'
require 'slacken/filters/sanitize_link'
require 'slacken/filters/sanitize_list'
require 'slacken/filters/sanitize_table'
require 'slacken/filters/stringfy_checkbox'
require 'slacken/filters/stringfy_emoji'
