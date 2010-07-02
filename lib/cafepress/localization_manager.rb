module Cafepress
  class LocalizationManager
    def self.included(controller)
      controller.send(:before_filter, :detect_locale)
    end
    
    protected
        
    def detect_locale
      detect_locale_from_ip unless params[LocaleRedirectController::LOCALE_REDIRECT_PARAM]
      locale = detect_locale_from_query_params
      locale = detect_locale_from_uri if locale.nil?
      locale ||= "en-US"
      I18n.locale = locale
    end
    
    private
    
    def detect_locale_from_ip
      logger.info "the request referer is #{request.referer}"
      logger.info "the current locale domain is #{I18n.t(Rails.env)[:domain]}"
      
      unless request.referer =~ /#{I18n.t(Rails.env)[:domain]}/
        locale = CafepressGeoIp.locale_by_ip(request.remote_ip)
        if locale && locale != I18n.locale
          I18n.locale = locale
          intended_host = determine_intended_host
          if intended_host
            redirect_to "#{request.protocol}#{intended_host}#{request.env["REQUEST_URI"]}", :status => "301"
          end
        end
      end
    end
        
    def determine_intended_host
      domain = request.host.split(".").first
      logger.info "determine_intended_host: domain = #{domain}"
      I18n.t(Rails.env).values.each  do |item|  logger.info item end
      logger.info  "detect = #{I18n.t(Rails.env).values.detect { |d| d.split('.').first == domain }}"
      I18n.t(Rails.env).values.detect { |d| d.split(".").first == domain }
    end
    
    def detect_locale_from_uri
      I18n.available_locales.each do |locale|
        return locale if request.host.split('.').detect { |uri_piece| locale.to_s.match(/#{uri_piece}/i) }
      end
      nil
    end
    
    def detect_locale_from_query_params
      params[:locale] if params[:locale]
    end
  end
end
