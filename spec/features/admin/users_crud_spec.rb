require "rails_helper"

RSpec.describe "Admin Users CRUD", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    # Add notes accessor to User if not present (used in form but not in model)
    User.class_eval { attr_accessor :notes } unless User.method_defined?(:notes)

    %w[index show new create edit update destroy archive unarchive].each do |operation|
      permission = create(:system_permission,
        name: "User #{operation.titleize}",
        resource: "User",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:user_1) { create(:user, first_name: "Alice", last_name: "Smith") }
    let!(:user_2) { create(:user, first_name: "Bob", last_name: "Jones") }

    it "displays a list of users" do
      visit "/admin/users"

      expect(page).to have_content("Alice")
      expect(page).to have_content("Bob")
    end
  end

  describe "show page" do
    let!(:target_user) { create(:user, first_name: "Test", last_name: "User", email: "testuser@example.com") }

    it "displays user details" do
      visit "/admin/users/#{target_user.id}"

      expect(page).to have_content("Test")
      expect(page).to have_content("User")
      expect(page).to have_content("testuser@example.com")
    end
  end

  describe "new page" do
    it "displays the new user form" do
      visit "/admin/users/new"

      expect(page).to have_field("Email")
      expect(page).to have_field("First name")
      expect(page).to have_field("Last name")
      expect(page).to have_button("Submit")
    end
  end

  describe "edit page" do
    let!(:target_user) { create(:user, first_name: "Original", last_name: "Name") }

    it "displays the edit user form with current values" do
      visit "/admin/users/#{target_user.id}/edit"

      expect(page).to have_field("First name", with: "Original")
      expect(page).to have_field("Last name", with: "Name")
      expect(page).to have_button("Submit")
    end
  end
end
