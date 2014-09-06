class OpenStruct

  def initialize_clone(other)
    super
    self.each_pair do |key, value|
      if value.is_a?(OpenStruct)
        self[key] = value.clone
      elsif value.is_a?(Enumerable)
        if value.respond_to?(:each_pair)
          self[key] = value.clone
          self[key] = self[key].each_pair do |k, v|
            self[key][k] = v.clone rescue v
          end
        elsif value.respond_to?(:map)
          self[key] = value.map { |x| x.clone rescue x }
        end
      end
    end
  end

end
