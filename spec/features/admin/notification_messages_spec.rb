require "rails_helper"

RSpec.describe "Admin Notification Messages", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    %w[index show].each do |operation|
      permission = create(:system_permission,
        name: "NotificationMessage #{operation.titleize}",
        resource: "NotificationMessage",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:topic) { create(:notification_topic) }
    let!(:message_1) { create(:notification_message, notification_topic: topic, subject: "Welcome Email") }
    let!(:message_2) { create(:notification_message, notification_topic: topic, subject: "Order Confirmation") }

    it "displays a list of notification messages" do
      visit "/admin/notification_messages"

      expect(page).to have_content("Welcome Email")
      expect(page).to have_content("Order Confirmation")
    end
  end

  describe "show page" do
    let!(:topic) { create(:notification_topic, name: "Test Topic") }
    let!(:target_message) { create(:notification_message, notification_topic: topic, subject: "Test Subject", body: "Test body content") }

    it "displays notification message details" do
      visit "/admin/notification_messages/#{target_message.id}"

      expect(page).to have_content("Test Subject")
      expect(page).to have_content("Test body content")
    end
  end
end
