#!/usr/bin/env ruby
require 'fileutils'

IGNORED_FILES = [
  '.',
  '..',
  '.gitignore',
  '.git',
  'bin',
  'install',
  'README.md'
]

puts 'Creating symlinks'
puts '------------------------------'

# install symlinks for dotfiles to ~/.file_name
Dir.foreach('.') do |item|
  target = "#{ENV['HOME']}/.#{item}"
  current_path = File.expand_path(File.dirname(File.dirname(__FILE__)))
  next if IGNORED_FILES.include? item
  next if File.symlink? target

  if File.exists? target
    puts "WARNING: #{item} exists but is not a symlnk"
    next
  end

  puts " + #{target}"
  `ln -s #{current_path}/#{item} #{target}`
end

# install symlinks to scripts in /usr/local/bin/file_name
Dir.foreach('bin') do |item|
  target = "/usr/local/bin/#{item}"
  current_path = File.expand_path(File.dirname(File.dirname(__FILE__)))
  next if IGNORED_FILES.include? item
  next if File.symlink? target

  if File.exists? target
    puts "WARNING: #{item} exists but is not a symlnk"
    next
  end

  puts " + #{target}"
  `ln -s #{current_path}/bin/#{item} #{target}`
end
