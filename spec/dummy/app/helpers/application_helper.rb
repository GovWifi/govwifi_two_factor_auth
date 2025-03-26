module ApplicationHelper
  def render_flash
    flash.map { |name, message|
      content_tag(:p, message, class: "flash #{name}")
    }.join.html_safe
  end
end
