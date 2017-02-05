module HooksDSL
  def before_callbacks
    @@before_callbacks
  end

  def before(&hook : String ->)
    @@before_callbacks << hook
  end

  def after_callbacks
    @@after_callbacks
  end

  def after(&hook : String ->)
    @@after_callbacks << hook
  end
end

