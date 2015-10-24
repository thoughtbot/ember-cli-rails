feature "User views ember app", :js do
  scenario "with asset helpers" do
    visit root_path

    expect(page).to have_text "Welcome to Ember"
  end

  scenario "with index helper" do
    visit root_path(index_html: true)

    expect(page).to have_text "Welcome to Ember"
  end
end
