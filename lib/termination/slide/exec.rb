# encoding: utf-8
class Termination
  class Slide
    class Exec

      IMAGE = "feh --borderless --cycle-once --fullscreen --hide-pointer %s"
      VIDEO = "mplayer -nogui -really-quiet -fs %s"
      SCRIPT = "bundle exec %s"

      def self.show_image(*image_paths)
        self.new(IMAGE % image_paths.join(' '), false)
      end

      def self.show_video(video_path)
        self.new(VIDEO % video_path, false)
      end

      def self.show_script(script_path, show_output)
        self.new(SCRIPT % script_path, show_output)
      end

      def initialize(command, show_output = true)
        @command = command
        @show_output = show_output
      end

      def each_starting_at_row(row_num, num_cols, &block)
        system(@command, :out => @show_output ? $stdout : '/dev/null', :err => '/dev/null', :in => '/dev/null')
      end

      def height
        0
      end
    end
  end
end