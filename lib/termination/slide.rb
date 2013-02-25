# encoding: utf-8
require 'io/console'
require 'artii'
require 'coderay'

class Termination
  class Slide
    include Enumerable

    def initialize(top_offset = 0, &block)
      @num_rows, @num_cols = *$stdout.winsize
      @top_offset = top_offset
      @rows = []
      block.call(self) if block
      self
    end

    def each(&block)
      row_num = @top_offset
      @rows.each do |row|
        row.each_starting_at_row(row_num, @num_cols, &block)
        row_num += row.height
      end
    end

    def text(align = :center, &block)
      add Text.new(block.call(ANSI), align)
      self
    end

    def ascii_art(font = 'standard', &block)
      font = Artii::Base.new :font => font
      add Text.new(font.asciify(block.call))
      self
    end

    def code(language = 'ruby', &block)
      source = block.call
      source = source.read if source.respond_to?(:read)
      add Text.new(CodeRay.scan(source, language).term, :left)
      self
    end

    def external_command(show_output = true, &block)
      add Exec.new(block.call)
      self
    end

    def image(&block)
      add Exec.show_image(block.call)
      self
    end

    def video(&block)
      add Exec.show_video(block.call)
      self
    end

    def script(show_output = true, &block)
      add Exec.show_script(block.call, show_output)
      self
    end

    def br(num = 1)
      add Text.new_br(num)
      self
    end

    def hr(fleuron = ' ❦  ')
      add Text.new_hr(fleuron, @num_cols)
      self
    end

    def show
      ::Kernel.print ANSI.clear_screen
      self.each do |line|
        ::Kernel.print line
      end
      ::Kernel.print ANSI.cursor(@num_rows, @num_cols) + ''
    end

    protected

    def add(content)
      @rows << content
    end
  end
end