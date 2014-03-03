module BadgesToSVG
  class << self

    ROOT = 'https://img.shields.io'

    RULES = {
      :travis => [
        'https?://travis-ci\\.org/%{user}/%{repo}\\.png',
        '/travis/%{user}/%{repo}.svg'
      ]
    }

    def version
      '0.0.1'
    end

    def compile_pattern pat
      Regexp.new ("^#{pat.gsub(/%\{(\w+)\}/) { "(?<#{$1}>.+?)" }}$")
    end

    def replace(content)
      content
    end

  end
end
