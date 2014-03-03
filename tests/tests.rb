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

  def test_empty_file
    assert_equal("", BadgesToSVG.replace(""))
  end

  def test_simple_file
    ct = "# README\n\nHello World!"
   assert_equal(ct, BadgesToSVG.replace(ct))
  end

end


exit Test::Unit::AutoRunner.run
