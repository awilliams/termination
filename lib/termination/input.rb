class Termination
  class Input

    KEYS = {
      :right_arrow => "\e[C",
      :left_arrow  => "\e[D"
    }

    KeyMapping = Struct.new(:keys, :action)

    def initialize(&tap)
      # forward_keys = [' ', 'n', 'l', 'k', "\e[5~"], backward_keys = ['b', 'p', 'h', 'j', "\e[6~"], exit_keys = ['q']
      @mapped_keys = []
      tap.call(self) if tap
    end

    def map_keys(*keys, &action)
      @mapped_keys << KeyMapping.new.tap do |mapping|
        mapping.keys = keys
        mapping.action = action
      end
    end

    def process_input(input)
      @mapped_keys.each do |mapping|
        mapping.action.call(input) if mapping.keys.include?(input)
      end
    end

    def get_input
      $stdin.noecho { |noecho|
        noecho.getch.tap { |input|
          2.times { input << noecho.getch } if input == "\e"
        }
      }
    end

    def start
      loop do
        self.process_input(self.get_input)
      end
    end
  end
end