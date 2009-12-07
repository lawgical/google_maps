module GoogleMap
  class PinIcon < GoogleMap::Icon
    attr_accessor :pin_fill_color,
                  :text_color,
                  :star_fill_color,
                  :letter,
                  :icon, # see http://groups.google.com/group/google-chart-api/web/chart-types-for-map-pins?pli=1#pin_icons for available icons
                  :pin_shape, # One of 'pin', 'pin_star', 'pin_sleft', 'pin_sright'
                  :scale_factor,
                  :rotation,
                  :font_size,
                  :font_style, # "_" for normal face, "b" for boldface
                  :text

    def initialize(options = {})
      options[:width] ||= nil
      options[:height] ||= nil
      options[:shadow_width] ||= nil
      options[:shadow_height] ||= nil
      super(options)
      fix_anchor
    end

    def fix_anchor
      if pin_type =~ /^d_map_xpin/ && pin_shape == 'pin_star'
        self.anchor_x = 12
        self.anchor_y = 39
        self.info_anchor_y = 6
      end
    end

    # Will return one of:
    # 'd_map_pin_letter', 'd_map_pin_icon', 'd_map_xpin_letter', 'd_map_xpin_icon', 'd_map_spin'
    def pin_type
      return 'd_map_spin' if scale_factor || font_size || font_style || rotation || text
      return 'd_map_xpin_icon' if pin_shape && pin_shape != 'pin' && icon
      return 'd_map_xpin_letter' if pin_shape && pin_shape != 'pin' && letter
      return 'd_map_pin_icon' if icon
      return 'd_map_pin_letter' if letter
      raise "Unknown pin_type, invalid options"
    end

    # Will return one of:
    # 'd_map_pin_shadow', 'd_map_xpin_shadow'
    def shadow_type
      if pin_type =~ /^d_map_xpin_/
        return 'd_map_xpin_shadow'
      else
        return 'd_map_pin_shadow'
      end
    end

    def pin_path
      url = "http://chart.apis.google.com/chart?chst=#{pin_type}&chld="
      self.pin_fill_color ||= "FFFFFF"

      case pin_type
      when 'd_map_pin_letter'
        self.text_color ||= "000000"
        url << "#{letter}|#{pin_fill_color}|#{text_color}"
      when 'd_map_pin_icon'
        url << "#{icon}|#{pin_fill_color}"
      when 'd_map_xpin_letter'
        self.text_color ||= "000000"
        self.star_fill_color ||= "0"
        url << "#{pin_shape}|#{letter}|#{pin_fill_color}|#{text_color}|#{star_fill_color}"
      when 'd_map_xpin_icon'
        self.star_fill_color ||= "0"
        url << "#{pin_shape}|#{icon}|#{pin_fill_color}|#{star_fill_color}"
      when 'd_map_spin'
        self.scale_factor ||= 1
        self.rotation ||= 0
        self.font_size ||= 10
        self.font_style ||= "_"
        self.text ||= ""
        url << "#{scale_factor}|#{rotation}|#{pin_fill_color}|#{font_size}|#{font_style}|#{text}"
      end
      url
    end

    def shadow_path
      url = "http://chart.apis.google.com/chart?chst=#{shadow_type}"
      if shadow_type == 'd_map_xpin_shadow'
        url << "&chld=#{pin_shape}"
      end
      url
    end
  end
end