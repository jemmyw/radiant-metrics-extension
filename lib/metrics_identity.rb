module Metrics
  module Identity
    def vanity_cookies
      @vanity_cookies ||= begin
        if respond_to?(:cookies)
          cookies
        else
          ActionController::CookieJar.new(self)
        end
      end
    end

    # Identify user for vanity
    def vanity_identity
      if vanity_cookies
        @vanity_identity = vanity_cookies['vanity_id'] || ActiveSupport::SecureRandom.hex(16)
        vanity_cookies["vanity_id"] = {:value => @vanity_identity, :expires => 1.month.from_now}
        @vanity_identity
      end
    end
  end
end