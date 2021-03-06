require "rails_helper"

RSpec.describe "Merchants Index Page" do
  describe "As an Admin" do
    before :each do
      @bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    end
    it "displays all merchant accounts and their info" do
      visit "/admin/merchants"

      expect(page).to have_link(@bike_shop.name)
      expect(page).to have_content(@bike_shop.city)
      expect(page).to have_content(@bike_shop.state)
      expect(page).to have_link(@dog_shop.name)
      expect(page).to have_content(@dog_shop.city)
      expect(page).to have_content(@dog_shop.state)

      click_on @bike_shop.name

      expect(current_path).to eq("/admin/merchants/#{@bike_shop.id}")
      # The merchant's name is a link to their Merchant Dashboard at routes such as "/admin/merchants/5"
    end
    it "can disable a merchant account" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        expect(page).to have_button("Disable")
        click_on "Disable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Disabled")
      end
      expect(page).to have_content("Merchant has been disabled")
    end

    it "can inactivate disabled merchant's items" do
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Active")
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        expect(page).to have_button("Disable")
        click_on "Disable"
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Inactive")
    end

    it "can enable a merchant account" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Disable"
        expect(page).to have_button("Enable")
        click_on "Enable"
        expect(current_path).to eq("/admin/merchants")
        expect(page).to have_content("Enabled")
      end
      expect(page).to have_content("Merchant's account is now enabled")
    end

    it "can activate enabled merchant's items" do
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Disable"
        expect(page).to have_content("Disabled")
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Inactive")
      visit "/admin/merchants"
      within(".merchants-#{@dog_shop.id}") do
        click_on "Enable"
        expect(page).to have_content("Enabled")
        expect(current_path).to eq("/admin/merchants")
      end
      visit "/items/#{@pull_toy.id}"
      expect(page).to have_content("Active")
    end
  end

  describe "As a merchant" do
    before :each do
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
      @user = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "tot@example.com", password: "password", role: 2)
      @user_1 = User.create!(name: "Tanya", address: "145 Uvula dr", city: "Lake", state: "Michigan", zip: 80203, email: "merch@example.com", password: "password", role: 1, merchant: @dog_shop)
      allow_any_instance_of(ApplicationController).to receive(:user).and_return(@user)
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it "can deactivate an item" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@pull_toy.id}") do
        expect(page).to have_content(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content(@pull_toy.price)
        expect(page).to have_css("img[src=\"#{@pull_toy.image}\"]")
        expect(page).to have_content("active")
        expect(page).to have_content(@pull_toy.inventory)
        click_on "deactivate"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item is no longer for sale")
      @pull_toy.reload
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@pull_toy.id}") do
        expect(page).to have_content("inactive")
      end
    end

    it "can activate an item" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content("inactive")
        click_on "activate"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item is now available for sale")
      @dog_bone.reload
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content("active")
      end
    end

    it "can delete an item" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        click_on "delete"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item has been deleted")
      @dog_shop.reload
      visit "/admin/merchants/#{@dog_shop.id}/items"
      expect(page).to_not have_content(@dog_bone.name)
    end

    it "cannot delete an item with orders" do
      order = @user_1.orders.create(name: "John", address: "124 Lickit dr", city: "Denver", state: "Colorado", zip: 80890)
      ItemOrder.create(item: @dog_bone, order: order, quantity: 7, price: 10)

      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        click_on "delete"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item has been ordered before and cannot be deleted")
    end

    it "can add an item" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      click_on "Add New Item"
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items/new")
      fill_in :name, with: "Dog Treat"
      fill_in :description, with: "Tastes great"
      fill_in :price, with: 3.50
      fill_in :inventory, with: 50
      click_on "Submit"
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item has been saved")
      expect(page).to have_content("Dog Treat")
      expect(page).to have_content("active")
      expect(page).to have_css("img[src=\"https://cateringbywestwood.com/wp-content/uploads/2015/11/dog-placeholder.jpg\"]")
    end

    it "cannot add an item if details are bad/missing" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      click_on "Add New Item"
      fill_in :name, with: "New Item"
      click_on "Submit"
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Price can't be blank")
      expect(page).to have_content("Inventory can't be blank")
      expect(find_field(:name).value).to eq('New Item')
    end

    it "can edit an item" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_content("inactive")
        click_on "edit"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items/#{@dog_bone.id}/edit")
      expect(find_field(:name).value).to eq(@dog_bone.name)
      expect(find_field(:description).value).to eq(@dog_bone.description)
      expect(find_field(:price).value).to eq("#{@dog_bone.price}")
      expect(find_field(:image).value).to eq(@dog_bone.image)
      expect(find_field(:inventory).value).to eq("#{@dog_bone.inventory}")
      fill_in :name, with: "Puppy bone"
      click_on "Save changes"
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items")
      expect(page).to have_content("Item has been updated")
      @dog_bone.reload
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content("Puppy bone")
        expect(page).to have_content("inactive")
      end
    end

    it "will not let item edit if info is bad" do
      visit "/admin/merchants/#{@dog_shop.id}/items"
      within(".items-#{@dog_bone.id}") do
        expect(page).to have_content(@dog_bone.name)
        expect(page).to have_content("inactive")
        click_on "edit"
      end
      expect(current_path).to eq("/admin/merchants/#{@dog_shop.id}/items/#{@dog_bone.id}/edit")
      expect(find_field(:name).value).to eq(@dog_bone.name)
      expect(find_field(:description).value).to eq(@dog_bone.description)
      expect(find_field(:price).value).to eq("#{@dog_bone.price}")
      expect(find_field(:image).value).to eq(@dog_bone.image)
      expect(find_field(:inventory).value).to eq("#{@dog_bone.inventory}")
      fill_in :name, with: ""
      click_on "Save changes"
      expect(page).to have_content("Name can't be blank")
      expect(find_field(:name).value).to eq("Dog Bone")
      expect(find_field(:description).value).to eq(@dog_bone.description)
      expect(find_field(:price).value).to eq("#{@dog_bone.price}")
      expect(find_field(:image).value).to eq(@dog_bone.image)
      expect(find_field(:inventory).value).to eq("#{@dog_bone.inventory}")
    end
  end
end
