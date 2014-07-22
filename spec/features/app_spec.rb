require "rspec"
require "capybara"
require "launchy"

feature "Messages" do
  scenario "As a user, I can submit a message" do
    visit "/"

    expect(page).to have_content("Message Roulette")

    fill_in "Message", :with => "Hello Everyone!"

    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
  end

  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"

    fill_in "Message", :with => "a" * 141

    click_button "Submit"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "when user clicks edit he should see form with message content" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"

    click_link "Edit"

    expect(page).to have_field("message", with: "Hello Everyone!")
    fill_in"message", with: "Bye!"
    click_button"Edit Message"
    expect(page).to have_content "Bye!"
  end
  scenario "As a user, I see an error message if I enter a message > 140 characters" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"

    click_link "Edit"

    fill_in "message", :with => "a" * 141
    click_button "Edit Message"

    expect(page).to have_content("Message must be less than 140 characters.")
  end

  scenario "user can delete messages" do
    visit "/"
    fill_in "Message", :with => "Hello Everyone!"
    click_button "Submit"

    expect(page).to have_content("Hello Everyone!")
    click_button "Delete"
    expect(page).to_not have_content("Hello Everyone!")
  end
end
