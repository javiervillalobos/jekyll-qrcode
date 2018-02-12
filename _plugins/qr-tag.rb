require 'rqrcode_png'

class QrCodeTag < Liquid::Tag
  def initialize(tag_name, url, tokens)
    super
    @url = url.strip
  end

  def lookup(context, name)
    lookup = context
    name.split(".").each { |value| lookup = lookup[value] }
    lookup
  end

  def render(context)
    page_url = "#{@url}"
    qr = RQRCode::QRCode.new(page_url)
    png = qr.as_png(
          fill: 'white',
          color: 'black',
          size: 120,
          border_modules: 1,
          )
    svg = qr.as_svg(offset: 0, color: '000', 
          shape_rendering: 'crispEdges', 
          module_size: 11)
    #png = svg.to_img
    <<-MARKUP.strip
    <div class="qrcode">
      <img src="#{png.to_data_url}" alt="#{page_url}">
    </div>
    MARKUP
  end
end

Liquid::Template.register_tag('qr', QrCodeTag)