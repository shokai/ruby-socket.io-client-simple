require 'rubygems'
require 'bundler/setup'
require 'minitest/autorun'

require File.expand_path 'server', File.dirname(__FILE__)

$:.unshift File.expand_path '../lib', File.dirname(__FILE__)
require 'socket.io-client-simple'
