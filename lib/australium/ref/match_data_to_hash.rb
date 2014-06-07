module Australium
  module MatchDataToHash

    refine MatchData do
      def to_h
        Hash[(self.names.empty? ? 1..self.captures.count : self.names.map { |x| x.to_sym }).zip(self.captures)]
      end
    end

  end
end
