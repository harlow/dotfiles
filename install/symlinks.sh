#!/usr/bin/env ruby
require 'fileutils'

ignored_files = [
  '.',
  '..',
  '.gitignore',
  '.git',
  'install',
  'README.md',
  'misc'
]

symlinks_created = []

Dir.foreach('.') do |item|
  target = "#{ENV['HOME']}/.#{item}"
  path = File.expand_path(File.dirname(File.dirname(__FILE__)))
  next if ignored_files.include? item
  next if File.symlink? target

  if File.exists? target
    puts "WARNING: #{item} exists but is not a symlnk"
  else
    symlinks_created << item
    `ln -s #{path}/#{item} #{target}`
  end
end

puts "#{symlinks_created.count} symlinks created"
