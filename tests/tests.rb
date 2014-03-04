#! /usr/bin/env ruby
# -*- coding: UTF-8 -*-

require 'coveralls'
Coveralls.wear!

require 'test/unit'
require 'simplecov'

test_dir = File.expand_path( File.dirname(__FILE__) )

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start { add_filter '/tests/' }

require 'badges2svg'

for t in Dir.glob( File.join( test_dir,  '*_tests.rb' ) )
  require t
end

class BadgesToSVGTests < Test::Unit::TestCase

  # == BadgesToSVG#version == #

  def test_version
    assert(BadgesToSVG.version =~ /^\d+\.\d+\.\d+/)
  end

  # == BadgesToSVG#compile_pattern == #

  def test_compile_pattern_empty
    assert_equal(/\b\b/, BadgesToSVG.compile_pattern(""))
  end

  def test_compile_pattern_no_special_chars
    assert_equal(/\bfoobar\b/, BadgesToSVG.compile_pattern("foobar"))
    assert_equal(/\bq-a yo\b/, BadgesToSVG.compile_pattern("q-a yo"))
  end

  def test_compile_pattern_with_special_chars
    assert_equal(/\bfoo.bar\b/, BadgesToSVG.compile_pattern("foo.bar"))
    assert_equal(/\ba?\b/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_one_field_name
    assert_equal(/\b(?<abc>.+?)\b/, BadgesToSVG.compile_pattern("%{abc}"))
    assert_equal(/\ba?\b/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_multiple_field_names
    assert_equal(/\b(?<a>.+?)\/(?<b>.+?)\b/,
                 BadgesToSVG.compile_pattern("%{a}/%{b}"))
  end

  # == BadgesToSVG#replace == #

  def test_replace_empty_file
    assert_equal("", BadgesToSVG.replace(""))
  end

  def test_replace_simple_file
    ct = "# README\n\nHello World!"
   assert_equal(ct, BadgesToSVG.replace(ct))
  end

  def test_replace_one_travis_https
    ct1 = "# README\n\nHello ![](https://travis-ci.org/usr/re.png)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re.svg)"
   assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_travis_http
    ct1 = "# README\n\nHello ![](http://travis-ci.org/usr/re.png)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re.svg)"
   assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_travis_branch_https
    ct1 = "# README\n\nHello ![](https://travis-ci.org/usr/re.png?branch=bx)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re/bx.svg)"
   assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

  def test_replace_one_travis_branch_http
    ct1 = "# README\n\nHello ![](http://travis-ci.org/usr/re.png?branch=aa)"
    ct2 = "# README\n\nHello ![](https://img.shields.io/travis/usr/re/aa.svg)"
   assert_equal(ct2, BadgesToSVG.replace(ct1))
  end

end


exit Test::Unit::AutoRunner.run
