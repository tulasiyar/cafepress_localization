$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'rubygems'

rbfiles = File.join(File.dirname(__FILE__), "cafepress", "**", "*.rb")
 
Dir.glob(rbfiles).each {|file| print file }
