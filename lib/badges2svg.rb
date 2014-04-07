module BadgesToSVG

  @protocol = 'https'
  @domain = 'img.shields.io'

  class << self

    # see http://shields.io/
    RULES = [
      { :name    => :travis_branch,
        :pattern => 'https?://(?:secure.)?travis-ci.org/%{user}/%{repo}.png' +
                      '\\?branch=%{branch}',
        :string  => 'travis-ci.org/%{user}/%{repo}.svg?branch=%{branch}',
        :domain  => true
      },
      {
        :name    => :travis,
        :pattern => 'https?://(?:secure.)?travis-ci.org/%{user}/%{repo}.png',
        :string  => 'travis-ci.org/%{user}/%{repo}.svg',
        :domain  => true
      },
      {
        :name    => :gittip,
        :pattern => 'https?://img.shields.io/gittip/%{user}.png',
        :string  => '/gittip/%{user}.svg'
      },
      {
        :name    => :coveralls_branch,
        :pattern => 'https?://coveralls.io/r(epos)?/%{user}/%{repo}/badge.png' +
                      '\\?branch=%{branch}',
        :string  => '/coveralls/%{user}/%{repo}/%{branch}.svg'
      },
      {
        :name    => :coveralls,
        :pattern => 'https?://coveralls.io/r(epos)?/%{user}/%{repo}/badge.png',
        :string  => '/coveralls/%{user}/%{repo}.svg'
      },
      {
        :name    => :gemnasium,
        :pattern => 'https?://gemnasium.com/%{user}/%{repo}.png',
        :string  => '/gemnasium/%{user}/%{repo}.svg'
      },
      {
        :name    => :code_climate,
        :pattern => 'https://codeclimate.com/github/%{user}/%{repo}.png',
        :string  => '/codeclimate/github/%{user}/%{repo}.svg'
      },

      {
        :name    => :gem_version,
        :pattern => 'https?://badge.fury.io/rb/%{repo}(?:@2x)?.png',
        :string  => '/gem/v/%{repo}.svg'
      },
      {
        :name    => :npm_version,
        :pattern => 'https?://badge.fury.io/js/%{repo}(?:@2x)?.png',
        :string  => '/npm/v/%{repo}.svg'
      },
      {
        :name    => :pypi_version,
        :pattern => 'https?://badge.fury.io/py/%{repo}(?:@2x)?.png',
        :string  => '/pypi/v/%{repo}.svg'
      },
      {
        :name    => :packagist_version,
        :pattern => 'https?://poser.pugx.org/%{user}/%{repo}/version.png',
        :string  => '/packagist/v/%{user}/%{repo}.svg'
      },

      {
        :name    => :packagist_downloads,
        :pattern => 'https?://poser.pugx.org/%{user}/%{repo}/d/total.png',
        :string  => '/packagist/dm/%{user}/%{repo}.svg'
      },
      {
        :name    => :pypi_downloads,
        :pattern => 'https?://pypip.in/d/%{repo}/badge.png',
        :string  => '/pypi/dm/%{repo}.svg'
      },

      {
        :name    => :misc_png,
        :pattern => 'https?://img.shields.io/%{path}.png',
        :string  => '/%{path}.svg'
      },
    ]

    def version
      '0.1.3'
    end

    def root_url(opts={})
      "#{opts[:protocol] || @protocol}://#{opts[:domain] || @domain}"
    end

    def compile_pattern(pat, *a)
      pat = pat.gsub(/\./, '\\.')
      Regexp.new ("\\b#{pat.gsub(/%\{(\w+)\}/, "(?<\\1>.+?)")}\\b")
    end

    def replace content, opts={}
      root = root_url(opts)
      RULES.each do |r|
        if r[:domain]
          myroot = root_url({}.update(opts).update({:domain => ''}))
        else
          myroot = root
        end

        pat  = compile_pattern(r[:pattern])
        repl = myroot + r[:string].gsub(/%\{(\w+)\}/, "\\\\k<\\1>")
        content.gsub!(pat, repl)
      end

      content
    end

  end
end
