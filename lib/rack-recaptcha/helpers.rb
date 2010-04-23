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
        options.reverse_merge! DEFAULT
        options[:public_key] ||= Rack::Recaptcha.public_key
        path = options[:ssl] ? RECAPTCHA_API_SECURE_URL : RECAPTCHA_API_URL
        html = case type.to_sym
        when :challenge
          (<<-CHALLENGE).gsub(/^ #{10}/,'')
          <script type="text/javascript" src="#{path}/challenge?k=#{options[:public_key]}">
          </script>
          CHALLENGE
        when :noscript
          (<<-NOSCRIPT).gsub(/^ #{10}/,'')
          <noscript>
          <iframe src="#{path}/noscript?k=#{options[:public_key]}" height="#{options[:height]}" width="#{options[:width]}" frameborder="0"></iframe><br>
          <textarea name="recaptcha_challenge_field" rows="#{options[:row]}" cols="#{options[:cols]}"></textarea>
          <input type="hidden" name="recaptcha_response_field" value="manual_challenge">
          </noscript>
          NOSCRIPT
        when :ajax
          (<<-AJAX).gsub(/^ #{10}/,'')
          <div id="ajax_recaptcha"></div>
          <script type="text/javascript" src="#{path}/js/recaptcha_ajax.js"></script>
          <script type="text/javascript">
          Recaptcha.create('#{options[:public_key]}', document.getElementById('ajax_recaptcha')#{options[:display] ? ',RecaptchaOptions' : ''});
          </script>
          AJAX
        else
          ""
        end
        if options[:display]
          (<<-DISPLAY).gsub(/^ #{10}/,'')
          <script type="text/javascript">
          var RecaptchaOptions = #{options[:display].to_json};
          </script>
          DISPLAY
        else
          ""
        end + html
      end

    end
  end
end
