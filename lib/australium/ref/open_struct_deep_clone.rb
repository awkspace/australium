module Australium
  module OpenStructDeepClone

    refine OpenStruct do
      def deep_clone
        dup = self.dup
        dup.each_pair do |key, value|
          dup[key] = value.deep_clone if value.is_a?(OpenStruct)
        end
        dup
      end
    end

  end
end
