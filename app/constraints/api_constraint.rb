class ApiConstraint
  attr_reader :version1

  def initialize(options)
    @version1 = options.fetch(:version1)
  end

  def matches?(request)
    Rails.logger.info "request Headers >>>>>>>> #{request.headers.fetch(:version1)}"
    Rails.logger.info "request Headers >>>>>>>> #{request.headers.fetch("Authorization")}"
    return true if request.url.match(/terms_of_use|data_protection/)
    request.headers.fetch(:version1).split(', ').last.eql?(version1.to_s)
  end
end
