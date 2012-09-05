require 'json'

module Rack
  class Recaptcha
    module Helpers

      DEFAULT= {
        :height => 300,
        :width => 500,
        :row => 3,
        :cols => 5
      }

      # Helper method to output a recaptcha form. Some of the available
      # types you can have are:
      #
      # :challenge - Returns a javascript recaptcha form
      # :noscript  - Return a non-javascript recaptcha form
      # :ajax      - Return a ajax recaptcha form
      #
      # You also have a few available options:
      #
      # For :ajax:
      #  :display    - You can adjust the display of the ajax form. An example:
      #                recaptcha_tag :ajax, :display => {:theme => 'red'}.
      # For :challenge and :noscript
      #  :public_key - Set the public key. Overrides the key set in Middleware option
      #  :height     - Adjust the height of the form
      #  :width      - Adjust the width of the form
      #  :row        - Adjust the rows for the challenge field
      #  :cols       - Adjust the column for the challenge field
      #  :language   - Set the language
      def recaptcha_tag(type= :noscript, options={})
        options = DEFAULT.merge(options)
        options[:public_key] ||= Rack::Recaptcha.public_key
        path = options[:ssl] ? Rack::Recaptcha::API_SECURE_URL : Rack::Recaptcha::API_URL
        params = "k=#{options[:public_key]}"
        params += "&hl=" + uri_parser.escape(options[:language].to_s) if options[:language]
        error_message = request.env['recaptcha.msg'] if defined?(request)
        params += "&error=" + uri_parser.escape(error_message) unless error_message.nil?
        html = case type.to_sym
        when :challenge
          %{<script type="text/javascript" src="#{path}/challenge?#{params}">
            </script>}.gsub(/^ +/, '')
        when :noscript
          %{<noscript>
            <iframe src="#{path}/noscript?#{params}" height="#{options[:height]}" width="#{options[:width]}" frameborder="0"></iframe><br>
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

      # Helper to return whether the recaptcha was accepted.
      def recaptcha_valid?
        test = Rack::Recaptcha.test_mode
        test.nil? ? request.env['recaptcha.valid'] : test
      end

      private

      def uri_parser
        @uri_parser ||= URI.const_defined?(:Parser) ? URI::Parser.new : URI
      end

    end
  end
end
