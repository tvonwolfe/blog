feature "Admin Login", type: :feature do
  before do
    allow(Rails.application.credentials).to receive(:admin_password).and_return("test1234")
  end

  scenario "Empty input results in no submission", js: true do
    visit new_admin_session_path

    expect { click_button "Log In" }.not_to change(page, :current_path)
    expect(page).to have_current_path(new_admin_session_path)
  end

  scenario "Incorrect password input results in no session creation", js: true do
    visit new_admin_session_path

    within "#session" do
      fill_in "Password", with: "wrong1234"
    end

    expect { click_button "Log In" }.not_to change(page, :current_path)
    expect(page).to have_current_path(new_admin_session_path)
  end

  scenario "Correct password input results in session creation" do
    visit new_admin_session_path
    within "#session" do
      fill_in "Password", with: "test1234"
    end
    click_button "Log In"

    expect(page).to have_current_path(admin_posts_path)
  end
end
