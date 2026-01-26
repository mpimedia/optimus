require "rails_helper"

RSpec.describe "Admin System Permissions CRUD", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    %w[index show new create edit update destroy archive unarchive].each do |operation|
      permission = create(:system_permission,
        name: "SystemPermission #{operation.titleize}",
        resource: "SystemPermission",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:permission_1) { create(:system_permission, name: "User Create") }
    let!(:permission_2) { create(:system_permission, name: "User Delete") }

    it "displays a list of system permissions" do
      visit "/admin/system_permissions"

      expect(page).to have_content("User Create")
      expect(page).to have_content("User Delete")
    end
  end

  describe "show page" do
    let!(:target_permission) { create(:system_permission, name: "Test Permission", description: "A test permission") }

    it "displays system permission details" do
      visit "/admin/system_permissions/#{target_permission.id}"

      expect(page).to have_content("Test Permission")
      expect(page).to have_content("A test permission")
    end
  end

  describe "new page" do
    it "displays the new system permission form" do
      visit "/admin/system_permissions/new"

      expect(page).to have_field("Name")
      expect(page).to have_button("Submit")
    end
  end

  describe "edit page" do
    let!(:target_permission) { create(:system_permission, name: "Original Permission") }

    it "displays the edit system permission form with current values" do
      visit "/admin/system_permissions/#{target_permission.id}/edit"

      expect(page).to have_field("Name", with: "Original Permission")
      expect(page).to have_button("Submit")
    end
  end
end
