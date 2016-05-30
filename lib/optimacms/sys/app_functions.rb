module Optimacms
  module Sys
    class AppFunctions
      def self.restart

        system("touch tmp/restart.txt")

        true
      end
    end
  end
end
