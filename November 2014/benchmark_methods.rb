#!/usr/bin/ruby
# encoding: utf-8
#
#  untitled.rb
#
#  Created by Dan MacLean (TSL) on 2014-11-19.
#  Copyright (c). All rights reserved.
#
require 'benchmark'
require 'pp'

class Perm
  
  def initialize length
    @ordered_list = (1..length).to_a.collect {|e| e.to_s }
    @shuffled_list = @ordered_list.shuffle
    @indexed_hash = make_hash @ordered_list
  end
  
  def make_hash list 
    Hash[list.collect.with_index {|v,i| [v,i].flatten }]
  end
  
  def delete_array
    while @ordered_list.length > 1
      @ordered_list.delete(@shuffled_list.shift)
      @ordered_list.delete(@shuffled_list.pop)
      @shuffled_list.shuffle
    end
    true
  end
  
  
  def delete_hash
   while @ordered_list.length > 1
      @ordered_list.delete_at(@indexed_hash[@shuffled_list.shift])
      @indexed_hash = make_hash @ordered_list
      @ordered_list.delete_at(@indexed_hash[@shuffled_list.pop])
      @indexed_hash = make_hash @ordered_list
      @shuffled_list.shuffle
    end
    true
  end
  
  def delete_compact
    while @ordered_list.compact.length > 1
      @ordered_list[@indexed_hash[@shuffled_list.shift]] = nil
      @ordered_list[@indexed_hash[@shuffled_list.pop]] = nil
      @shuffled_list.shuffle
    end
    true
  end
  
end



def benchmark_me n, length
  puts "Running #{n} times on a list #{length} long..."
  Benchmark.bm do |b|
    puts "by array..."
    b.report {n.times do ; p=Perm.new(length); p.delete_array; end}
    puts "by hash..."
    b.report {n.times do ; p=Perm.new(length); p.delete_hash; end}
    puts "by adding nil"
    b.report {n.times do ; p=Perm.new(length); p.delete_compact; end}
  end
end

lengths = [10,100,1000,10000]
times = [10,100,1000]

lengths.each do |l|
  times.each do |t|
    benchmark_me t,l
  end
end
