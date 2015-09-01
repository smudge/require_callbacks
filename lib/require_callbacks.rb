require 'require_callbacks/version'

module RequireCallbacks
  %w(load require require_relative).each do |m|
    define_method("after_#{m}") do |name, &block|
      @after_load ||= {}
      @after_load[name] ||= []
      @after_load[name] << block
    end

    define_method("before_#{m}") do |name, &block|
      @before_load ||= {}
      @before_load[name] ||= []
      @before_load[name] << block
    end

    define_method(m) do |*args|
      @after_load ||= {}
      @before_load ||= {}
      (@before_load[args.first] || []).each(&:call)
      super(*args) && !!(@after_load[args.first] || []).each(&:call)
    end
  end
end

Object.send :prepend, RequireCallbacks
class << Object
  prepend RequireCallbacks
end
