# encoding: UTF-8
require 'fileutils'

puts "Creating required folders ..."
puts "Created folders ..."
FileUtils::mkdir_p 'files_to_process'
puts "./files_to_process"
FileUtils::mkdir_p 'photos'
puts "./photos"
FileUtils::mkdir_p 'log'
puts "./log"
