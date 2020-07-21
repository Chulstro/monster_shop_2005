require "rails_helper"

RSpec.describe "User Login" do
  describe "As a visitor" do
    # it "displays a path to user login" do
    #   visit "/login"
    #
    #   user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")
    #
    #   expect(user.default?).to be_truthy
    #
    #   fill_in :email, with: "T-tar@gmail.com"
    #   fill_in :password, with: "Bangladesh134"
    #   click_on "Log In"
    #   expect(current_path).to eq("/profile")
    #   expect(page).to have_content("Welcome, #{user.name}!")
    # end
    #
    # it "displays a path to merchant login" do
    #   visit "/login"
    #
    #   user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1)
    #
    #   expect(user.merchant?).to be_truthy
    #
    #   fill_in :email, with: "T-tar@gmail.com"
    #   fill_in :password, with: "Bangladesh134"
    #   click_on "Log In"
    #   expect(current_path).to eq("/merchant/dashboard")
    #   expect(page).to have_content("Welcome, #{user.name}!")
    # end
    #
    # it "displays a path to merchant login" do
    #   visit "/login"
    #
    #   user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 2)
    #
    #   expect(user.admin?).to be_truthy
    #
    #   fill_in :email, with: "T-tar@gmail.com"
    #   fill_in :password, with: "Bangladesh134"
    #   click_on "Log In"
    #   expect(current_path).to eq("/admin/dashboard")
    #   expect(page).to have_content("Welcome, #{user.name}!")
    # end
    #
    # it "users cannot login with bad credentials" do
    #   visit "/login"
    #
    #   user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")
    #
    #   expect(user.default?).to be_truthy
    #
    #   fill_in :email, with: "T-tar@gmail.com"
    #   fill_in :password, with: "password"
    #   click_on "Log In"
    #   expect(current_path).to eq("/login")
    #   expect(page).to have_content("Sorry, your credentials are bad.")
    # end

    it "users who are already logged in are redirected" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134")

      expect(user.default?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/profile")
      expect(page).to have_content("You are already logged in")
    end

    it "merchants who are already logged in are redirected" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 1)

      expect(user.merchant?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/merchant/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/merchant/dashboard")
    end

    it "admins who are already logged in are redirected" do
      visit "/login"

      user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: "77967", email: "T-tar@gmail.com", password: "Bangladesh134", role: 2)

      expect(user.admin?).to be_truthy

      fill_in :email, with: "T-tar@gmail.com"
      fill_in :password, with: "Bangladesh134"
      click_on "Log In"
      expect(current_path).to eq("/admin/dashboard")
      expect(page).to have_content("Welcome, #{user.name}!")

      visit "/login"
      expect(current_path).to eq("/admin/dashboard")
    end
  end
end
