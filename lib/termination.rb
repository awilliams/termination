#!/usr/bin/env ruby
# encoding: utf-8
require "termination/version"
require 'io/console'
require 'artii'
require 'coderay'

class Termination
  attr_reader :slide_cursor

  def initialize(&block)
    @slides = []
    @slide_cursor = 0
    @input = Input.new do |input|
      input.map_keys(Input::KEYS[:right_arrow], ' ') do
        self.next_slide
      end
      input.map_keys(Input::KEYS[:left_arrow]) do
        self.previous_slide
      end
      input.map_keys(*(1..100).map(&:to_s)) do |num_pressed|
        self.show_slide(@slide_cursor = (num_pressed.to_i - 1))
      end
      input.map_keys('q', 'Q') do
        self.stop
      end
    end
    block.call(self) if block
  end

  def section(header, sub_header = nil, &block)
    @slides << Slide.new(2) { |slide|
      slide.hr.br.text{ |color|
        color.bold{ header }
      }.br.hr
      if sub_header
        slide.br.text { sub_header }
      end
    }
    block.call(self)
  end

  def slide(*args, &block)
    Slide.new(*args, &block).tap { |new_slide| @slides << new_slide }
  end

  def start
    self.show_slide(@slide_cursor)
    @input.start
  end

  def next_slide
    self.show_slide(@slide_cursor += 1)
  end

  def previous_slide
    self.show_slide(@slide_cursor -= 1)
  end

  def show_slide(index)
    @slides.fetch(self.normalize_slide_index(index)).show
  end

  def stop
    print ANSI.clear_screen
    exit
  end

  protected

  def normalize_slide_index(index)
    @index_range ||= (0..(@slides.length - 1))
    @index_range.include?(index) ? index : index % (@slides.length)
  end
end

require 'termination/input'
require 'termination/ansi'
require 'termination/slide'
require 'termination/slide/text'
require 'termination/slide/exec'