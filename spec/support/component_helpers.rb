module ComponentHelpers
  def render_fragment(...)
    html = render(...)
    Nokogiri::HTML5.fragment(html)
  end

  def render_document(...)
    html = render(...)
    Nokogiri::HTML5(html)
  end

  def render(...)
    view_context.render(...)
  end

  def view_context = controller.view_context

  def controller = @controller ||= ActionView::TestCase::TestController.new
end
