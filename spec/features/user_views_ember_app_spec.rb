feature "User views ember app", :js do
  scenario "with asset helpers" do
    visit page_path("embedded")

    expect(page).to have_javascript_rendered_text
  end

  scenario "with index helper" do
    visit page_path("include_index")

    expect(page).to have_javascript_rendered_text
    expect(page).to have_no_csrf_tags

    visit page_path("include_index_empty_block")

    expect(page).to have_javascript_rendered_text
    expect(page).to have_csrf_tags

    visit page_path("include_index_head_and_body")

    expect(page).to have_javascript_rendered_text
    expect(page).to have_csrf_tags
    expect(page).to have_rails_injected_text
  end

  def have_rails_injected_text
    have_text "Hello from Rails"
  end

  def have_javascript_rendered_text
    have_text("Welcome to Ember")
  end

  def have_no_csrf_tags
    have_no_css("meta[name=csrf-param]", visible: false).
      and have_no_css("meta[name=csrf-token]", visible: false)
  end

  def have_csrf_tags
    have_css("meta[name=csrf-param]", visible: false).
      and have_css("meta[name=csrf-token]", visible: false)
  end
end
