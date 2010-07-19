module Rack
  class Recaptcha
    module Helpers

      DEFAULT= {
        :height => 300,
        :width => 500,
        :row => 3,
        :cols => 5
      }

      def recaptcha_tag(type= :noscript, options={})
        options = DEFAULT.merge(options)
        options[:public_key] ||= Rack::Recaptcha.public_key
        path = options[:ssl] ? Rack::Recaptcha::API_SECURE_URL : Rack::Recaptcha::API_URL
        html = case type.to_sym
        when :challenge
          %{<script type="text/javascript" src="#{path}/challenge?k=#{options[:public_key]}">
            </script>}.gsub(/^ +/, '')
        when :noscript
          %{<noscript>
            <iframe src="#{path}/noscript?k=#{options[:public_key]}" height="#{options[:height]}" width="#{options[:width]}" frameborder="0"></iframe><br>
            <textarea name="recaptcha_challenge_field" rows="#{options[:row]}" cols="#{options[:cols]}"></textarea>
            <input type="hidden" name="recaptcha_response_field" value="manual_challenge">
            </noscript>}.gsub(/^ +/, '')
        when :ajax
          %{<div id="ajax_recaptcha"></div>
            <script type="text/javascript" src="#{path}/js/recaptcha_ajax.js"></script>
            <script type="text/javascript">
            Recaptcha.create('#{options[:public_key]}', document.getElementById('ajax_recaptcha')#{options[:display] ? ',RecaptchaOptions' : ''});
            </script>}.gsub(/^ +/, '')
        else
          ''
        end
        if options[:display]
          %{<script type="text/javascript">
            var RecaptchaOptions = #{options[:display].to_json};
            </script>}.gsub(/^ +/, '')
        else
          ''
        end + html
      end

      def recaptcha_valid?
        request.env['recaptcha.valid']
      end

    end
  end
end
