# This module’s main method is {BadgesToSVG#replace}. It’s used to parse a
# string and replace links to PNG badge images with resolution-independent
# (SVG) ones. This is used by a command-line tool called +badges2svg+.
module BadgesToSVG

  # @return [String] default protocol
  attr_reader :protocol

  # @return [String] default domain
  attr_reader :domain

  @protocol = 'https'

  @domain = 'img.shields.io'

  class << self

    # Rules for PNG to SVG replacements. This array is intentionally ordered,
    # because some rules might match the same pattern, so the greedier ones
    # should go first. A rule is a hash with the following keys:
    # - +:name+: the rule's name. This must be unique.
    # - +:pattern+ the PNG URL pattern. See {BadgesToSVG#compile_pattern} for a
    #   pattern overview.
    # - +:string+ the URL replacement. It should start with a slash (+/+)
    #   because by default URLs are under the +http://shields.io+ domain (see
    #   {#domain}). If you wish to link to a different domain, use it but don't
    #   include the protocol part (e.g. +http://+)
    # - +:domain+ (optional): if you specified a custom domain in the +:string+
    #   key, set this one to +true+ to tell +BadgesToSVG+ to not prepend the
    #   default domain.
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

    # @return [String] current gem version
    def version
      '0.1.3'
    end

    # Create a root URL. If nothing is passed, it uses the default protocol and
    # default domain
    # @param opts [Hash] use this parameter to override default protocol
    #                    (+:protocol+) and (+:domain+).
    # @see BadgesToSVG#protocol
    # @see BadgesToSVG#domain
    def root_url(opts={})
      "#{opts[:protocol] || @protocol}://#{opts[:domain] || @domain}"
    end

    # Compile a pattern into a regular expression. Patterns are used as handy
    # shortcuts to extract a part of an URL. A pattern written as +%{foo}+ in a
    # string is compiled into a +Regexp+ that matches an alphanumeric word into
    # a group called <i>foo</i>.
    # @param pattern [String]
    # @return [Regexp] compiled pattern
    def compile_pattern(pattern)
      patttern = pattern.gsub!(/\./, '\\.')
      Regexp.new ("\\b#{pattern.gsub(/%\{(\w+)\}/, "(?<\\1>.+?)")}\\b")
    end

    # Replace PNG image URLs with SVG ones when possible in a given string
    # content. This is meant to be used on a README or similar file.
    # @param content [String]
    # @param opts [Hash] this hash is passed to {BadgesToSVG#root_url} and thus
    #                    can be used to override the default protocol and
    #                    domain.
    # @return [String] the same content with replaced URLs
    # @see RULES
    def replace(content, opts={})
      root = root_url(opts)
      RULES.each do |r|
        if r[:domain]
          myroot = root_url({}.update(opts).update({:domain => ''}))
        else
          myroot = root
        end

        pat  = compile_pattern(r[:pattern])
        replacement = myroot + r[:string].gsub(/%\{(\w+)\}/, "\\\\k<\\1>")
        content.gsub!(pat, replacement)
      end

      content
    end

  end
end
