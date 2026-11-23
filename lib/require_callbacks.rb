require 'require_callbacks/version'

module RequireCallbacks
  BEFORE_CALLBACKS = {}
  AFTER_CALLBACKS = {}

  def callback_name(name)
    name.to_s.sub(/\.rb\z/, '')
  end

  def after_require(name, &block)
    raise ArgumentError, 'callback block required' unless block
    (AFTER_CALLBACKS[callback_name(name)] ||= []) << block
  end

  def before_require(name, &block)
    raise ArgumentError, 'callback block required' unless block
    (BEFORE_CALLBACKS[callback_name(name)] ||= []) << block
  end

  def require(*args)
    (BEFORE_CALLBACKS[callback_name(args.first)] || []).each(&:call)
    loaded = super
    (AFTER_CALLBACKS[callback_name(args.first)] || []).each(&:call) if loaded
    loaded
  end
end

Object.send :prepend, RequireCallbacks
class << Object
  prepend RequireCallbacks
end
