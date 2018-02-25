require 'rqrcode_png'
require 'net/http'
require 'json'
require 'uri'

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
    uri = URI.parse('http://34.237.175.114:8080/cdc19790505/cl5bm2mb2rs')
	  http = Net::HTTP.new(uri.host, uri.port)
	  request = Net::HTTP::Get.new(uri.request_uri)
	  request["Accept"] = "application/json"
  
    resultado = http.request(request)

    partners = JSON.parse(resultado.body)
    partner = partners[0]
    html = ""
    for partner in partners do
      page_url = "http://34.237.175.114:8080/cdc19790505cl5bm2mb2rs//gethtmlinfo?token=#{partner['token']}"
      qr = RQRCode::QRCode.new(page_url)
      png = qr.as_png(
            fill: 'white',
            color: 'black',
            size: 120,
            border_modules: 1,
            )
      html += "<div class=\"qrcode\"><span><a href=\"#{page_url}\">#{partner['rut']}</a></span>"
      html += "<div><img src=\"#{png.to_data_url}\" alt=\"#{page_url}\"></div></div>\n"
    end
    <<-MARKUP.strip
    #{html}
    MARKUP
    #png = svg.to_img
  end
end

Liquid::Template.register_tag('qr', QrCodeTag)