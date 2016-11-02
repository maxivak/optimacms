module Optimacms
  module FilterHelper

    def self.for_select_yes_no(title_all)
      a = [[title_all, -1], ["yes", 1], ["no", 0]]
      a
    end


  end
end
