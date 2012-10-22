#!/usr/bin/env ruby
require 'fileutils'

ignored_files = [
  '.',
  '..',
  '.gitignore',
  '.git',
  'install',
  'README.md',
  'bin'
]

symlink_count = 0

Dir.foreach('.') do |item|
  target = "#{ENV['HOME']}/.#{item}"
  path = File.expand_path(File.dirname(File.dirname(__FILE__)))

  next if ignored_files.include? item
  next if File.symlink? target

  if File.exists? target
    puts "WARNING: #{item} exists but is not a symlnk"
    next
  end

  symlink_count = symlink_count + 1
  `ln -s #{path}/#{item} #{target}`
end

Dir.foreach('bin') do |item|
  target = "/usr/local/bin/#{item}"
  path = File.expand_path(File.dirname(File.dirname(__FILE__)))

  next if item == '.' or item == '..'
  next if File.symlink? target

  symlink_count = symlink_count + 1
  `ln -s #{path}/bin/#{item} #{target}`
end

puts "#{symlink_count} symlinks created"
