feature "User views ember app" do
  scenario "with Rails assets issue#212" do
    visit page_path("issue_212")

    expect(page).to have_css("link[rel=stylesheet]", visible: false)
  end
end
