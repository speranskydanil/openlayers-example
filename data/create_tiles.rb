#!/usr/bin/env ruby

require 'fileutils'
require 'paperclip'

def spawn_wait(cmd)
  pid = Process.spawn(cmd)
  Process.wait(pid)
end

fn = 'image.jpg'

g = Paperclip::Geometry.from_file("#{__dir__}/#{fn}")

w = g.width
h = g.height

if w / h > 2
  nw = w
  nh = w / 2
else
  nw = h * 2
  nh = h
end

spawn_wait "convert #{__dir__}/#{fn} -bordercolor '#eee' -border #{(nw - w) / 2}x#{(nh - h) / 2} #{__dir__}/_#{fn}"

(2..6).each do |zoom|
  FileUtils.rm_rf "#{__dir__}/#{zoom}"
  Dir.mkdir "#{__dir__}/#{zoom}"

  spawn_wait "convert #{__dir__}/_#{fn} -resize #{256 * 2**zoom}x#{128 * 2**zoom} #{__dir__}/__#{fn}"

  spawn_wait "convert #{__dir__}/__#{fn} -crop 256x256 -set filename:tile '%[fx:page.x/256]_%[fx:page.y/256]' #{__dir__}/#{zoom}/%[filename:tile].jpg"

  File.delete "#{__dir__}/__#{fn}"
end

File.delete "#{__dir__}/_#{fn}"

