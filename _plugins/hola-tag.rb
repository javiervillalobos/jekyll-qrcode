class HolaTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
  end

  def render(context)
    output =  "<span>hola</span>"
    return output;
  end
end
Liquid::Template.register_tag('hola', HolaTag)