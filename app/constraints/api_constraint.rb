class ApiConstraint
  attr_reader :version

  def initialize(options)
    @version = options.fetch(:version)
  end

  def matches?(request)
    puts "request Headers >>>>>>>> #{request.headers.fetch(:version)}"
    Rails.logger.info "request Headers >>>>>>>> #{request.headers.fetch(:version)}"
    return true if request.url.match(/terms_of_use|data_protection/)
    request
      .headers
      .fetch(:version)
      .split(', ')
      .last
      .eql?(version.to_s)
  end
end
