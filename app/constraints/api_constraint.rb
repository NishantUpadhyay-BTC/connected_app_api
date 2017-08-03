class ApiConstraint
  attr_reader :version

  def initialize(options)
    @version = options.fetch(:version)
  end

  def matches?(request)
    request
      .headers
      .fetch(:version)
      .split(', ')
      .last
      .eql?(version.to_s)
  end
end
