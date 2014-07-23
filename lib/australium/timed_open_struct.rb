class TimedOpenStruct < OpenStruct

  def initialize(*args)
    super(*args)
    @table_history = Hash.new { |h,k| h[k] = {} }
  end

  def [](name, timestamp = nil)
    if timestamp.nil?
      @table[name.to_sym]
    else
      keys = @table_history[name.to_sym].keys.reverse
      key = keys.find(lambda {keys.last}) do |x|
        x <= timestamp
      end
      @table_history[name.to_sym][key]
    end
  end

  def []=(name, *args, value)
    @table[name.to_sym] = value
    unless args.empty?
      args.each do |timestamp|
        @table_history[name.to_sym].merge!({ timestamp => value })
      end
      @table_history[name.to_sym].replace(@table_history[name.to_sym].sort.to_h)
    end
  end

  def durations(name)
    nil unless @table_history.include?(name.to_sym)

    duration_table = Hash.new(0)
    @table_history[name.to_sym].each_with_index do |(timestamp, value), index|
      duration_table[value] += index == @table_history[name.to_sym].count - 1 ? 0.0 : @table_history[name.to_sym].keys[index + 1] - timestamp
    end

    duration_table
  end


end
