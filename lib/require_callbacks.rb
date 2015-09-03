require 'require_callbacks/version'

module RequireCallbacks
  def after_require(name, &block)
    @after_require ||= {}
    @after_require[name] ||= []
    @after_require[name] << block
  end

  def before_require(name, &block)
    @before_require ||= {}
    @before_require[name] ||= []
    @before_require[name] << block
  end

  def require(*args)
    @after_require ||= {}
    @before_require ||= {}
    (@before_require[args.first] || []).each(&:call)
    super && !!(@after_require[args.first] || []).each(&:call)
  end
end

Object.send :prepend, RequireCallbacks
class << Object
  prepend RequireCallbacks
end
