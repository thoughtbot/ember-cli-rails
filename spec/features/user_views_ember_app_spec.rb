feature "User views ember app", :js do
  scenario "with asset helpers" do
    visit root_path

    expect(page).to have_text "Welcome to Ember"
    expect(page).to have_csrf_tags
  end

  scenario "with index helper" do
    visit root_path(index_html: true)

    expect(page).to have_text "Welcome to Ember"
    expect(page).to have_no_csrf_tags

    visit root_path(index_html: true, empty_block: true)

    expect(page).to have_csrf_tags

    visit root_path(index_html: true, head_and_body: true)

    expect(page).to have_csrf_tags
    expect(page).to have_text "Hello from Rails"
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
