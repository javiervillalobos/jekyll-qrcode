require 'rqrcode_png'
require 'json'
require 'rest-client'

class MemberTag < Liquid::Tag
  def initialize(tag_name, token, tokens)
    super
    @token = token
  end

  def lookup(context, name)
    lookup = context
    name.split(".").each { |value| lookup = lookup[value] }
    lookup
  end

  def render(context)
    resultado = RestClient::Request.execute(
      method: :get, 
      url: 'http://localhost:8080/cdc19790505/cl5bm2mb2rs/1', 
      headers: { accept: :json })
    partner = JSON.parse(resultado.body)
    html = "<div>#{partner['rut']}</div>\n"
    <<-MARKUP.strip
    #{html}
    MARKUP
    #png = svg.to_img
  end
end

Liquid::Template.register_tag('member', MemberTag)