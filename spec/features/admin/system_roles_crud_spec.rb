require "rails_helper"

RSpec.describe "Admin System Roles CRUD", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    %w[index show new create edit update destroy archive unarchive].each do |operation|
      permission = create(:system_permission,
        name: "SystemRole #{operation.titleize}",
        resource: "SystemRole",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:role_1) { create(:system_role, name: "Administrators") }
    let!(:role_2) { create(:system_role, name: "Editors") }

    it "displays a list of system roles" do
      visit "/admin/system_roles"

      expect(page).to have_content("Administrators")
      expect(page).to have_content("Editors")
    end
  end

  describe "show page" do
    let!(:target_role) { create(:system_role, name: "Test Role", description: "A test role") }

    it "displays system role details" do
      visit "/admin/system_roles/#{target_role.id}"

      expect(page).to have_content("Test Role")
      expect(page).to have_content("A test role")
    end
  end

  describe "new page" do
    it "displays the new system role form" do
      visit "/admin/system_roles/new"

      expect(page).to have_field("Name")
      expect(page).to have_button("Submit")
    end
  end

  describe "edit page" do
    let!(:target_role) { create(:system_role, name: "Original Role") }

    it "displays the edit system role form with current values" do
      visit "/admin/system_roles/#{target_role.id}/edit"

      expect(page).to have_field("Name", with: "Original Role")
      expect(page).to have_button("Submit")
    end
  end
end
