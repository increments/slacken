module Slacken
  module SlackUrl
    def self.link_tag(title, url)
      "<#{url}|#{title}>"
    end
  end
end
