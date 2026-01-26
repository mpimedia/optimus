require "rails_helper"

RSpec.describe "Admin Data Logs", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    %w[index show].each do |operation|
      permission = create(:system_permission,
        name: "DataLog #{operation.titleize}",
        resource: "DataLog",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:data_log_1) { create(:data_log, operation: "create", note: "Created a record") }
    let!(:data_log_2) { create(:data_log, operation: "update", note: "Updated a record") }

    it "displays a list of data logs" do
      visit "/admin/data_logs"

      expect(page).to have_content("create")
      expect(page).to have_content("update")
    end
  end

  describe "show page" do
    let!(:target_log) { create(:data_log, operation: "delete", note: "Deleted the item") }

    it "displays data log details" do
      visit "/admin/data_logs/#{target_log.id}"

      expect(page).to have_content(/delete/i)
      expect(page).to have_content("Deleted the item")
    end
  end
end
