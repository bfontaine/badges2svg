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
    assert_equal(/^$/, BadgesToSVG.compile_pattern(""))
  end

  def test_compile_pattern_no_special_chars
    assert_equal(/^foobar$/, BadgesToSVG.compile_pattern("foobar"))
    assert_equal(/^q-a yo$/, BadgesToSVG.compile_pattern("q-a yo"))
  end

  def test_compile_pattern_with_special_chars
    assert_equal(/^foo.bar$/, BadgesToSVG.compile_pattern("foo.bar"))
    assert_equal(/^a?$/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_one_field_name
    assert_equal(/^(?<abc>.+?)$/, BadgesToSVG.compile_pattern("%{abc}"))
    assert_equal(/^a?$/, BadgesToSVG.compile_pattern("a?"))
  end

  def test_compile_pattern_with_multiple_field_names
    assert_equal(/^(?<a>.+?)\/(?<b>.+?)$/,
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

end


exit Test::Unit::AutoRunner.run
