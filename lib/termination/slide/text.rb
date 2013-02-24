# encoding: utf-8
class Termination
  class Slide
    class Text
      def self.new_br(num)
        self.new([''] * num)
      end

      def self.new_hr(fleuron, num_cols)
        line_length = [1, 1 + (num_cols - fleuron.length) / 4].max
        line = '─' * line_length
        self.new("#{line}#{fleuron}#{line}")
      end

      attr_reader :row_width, :align

      def initialize(content, align = :center)
        @content = content.respond_to?(:each) ? content : content.split("\n")
        @align = align
      end

      def width
        @width ||= @content.map{ |line| line.strip.gsub(ANSI::NON_ANSI, '').length }.max
      end

      def height
        @height ||= @content.length
      end

      def begins_at_column(line, max_width)
        case self.align
          when :center
            line_width = line.chomp.gsub(ANSI::NON_ANSI, '').length
            [1, 1 + (max_width - line_width) / 2].max
          when :center_all
            [1, 1 + (max_width - self.width) / 2].max
          when :left
            1
          else
            self.align
        end
      end

      def each_starting_at_row(row, max_width, &block)
        @content.each do |line|
          block.call ANSI.cursor(row += 1, self.begins_at_column(line, max_width)) + line
        end
      end
    end
  end
end