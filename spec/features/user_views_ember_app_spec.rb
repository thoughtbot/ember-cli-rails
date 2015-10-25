feature "User views ember app", :js do
  scenario "from root" do
    visit root_path

    expect(page).to have_text "Welcome to Ember"
  end
end
