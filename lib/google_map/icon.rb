module GoogleMap

  class Icon
    #include Reloadable
    #include UnbackedDomId

    attr_accessor :map,
                  :dom_id,
                  :width,
                  :height,
                  :shadow_width,
                  :shadow_height,
                  :image_url,
                  :shadow_url,
                  :anchor_x,
                  :anchor_y,
                  :info_anchor_x,
                  :info_anchor_y

    def initialize(options = {})
      self.image_url       = options[:map].ssl ? 'https://maps-api-ssl.google.com/intl/en_us/mapfiles/marker.png' : 'http://www.google.com/intl/en_us/mapfiles/marker.png'
      self.shadow_url      = options[:map].ssl ? 'https://maps-api-ssl.google.com/intl/en_us/mapfiles/shadow50.png' : 'http://www.google.com/intl/en-us/mapfiles/shadow50.png'
      self.width           = 20
      self.height          = 34
      self.shadow_width    = 37
      self.shadow_height   = 34
      self.anchor_x        = 11
      self.anchor_y        = 34
      self.info_anchor_x   = 5
      self.info_anchor_y   = 1
      options.each_pair { |key, value| send("#{key}=", value) }

      if !map or !map.kind_of?(GoogleMap::Map)
        raise "Must set map for GoogleMap::Icon."
      end
      if dom_id.blank?
        self.dom_id = "#{map.dom_id}_icon_#{map.markers.size + 1}"
      end

    end

    def pin_path
      self.image_url
    end

    def shadow_path
      self.shadow_url
    end

    def to_js
      js = []
      js << "var #{dom_id} = new GIcon();"
      js << "#{dom_id}.image = \"#{pin_path}\";"
      js << "#{dom_id}.shadow = \"#{shadow_path}\";"
      js << "#{dom_id}.iconSize = new GSize(#{width}, #{height});" if width && height
      js << "#{dom_id}.shadowSize = new GSize(#{shadow_width}, #{shadow_height});" if shadow_width && shadow_height
      js << "#{dom_id}.iconAnchor = new GPoint(#{anchor_x}, #{anchor_y});"
      js << "#{dom_id}.infoWindowAnchor = new GPoint(#{info_anchor_x}, #{info_anchor_y});"
      return js.join("\n")
    end

    def to_html
      html = []
      html << "<script type=\"text/javascript\">\n/* <![CDATA[ */\n"
      html << to_js
      html << "/* ]]> */</script> "
      return html.join("\n")
    end

  end

end