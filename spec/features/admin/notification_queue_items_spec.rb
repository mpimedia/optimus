require "rails_helper"

RSpec.describe "Admin Notification Queue Items", type: :feature do
  let(:user) { create(:user) }
  let(:auth_system_group) { create(:system_group) }
  let(:system_role) { create(:system_role) }

  before do
    %w[index show].each do |operation|
      permission = create(:system_permission,
        name: "NotificationQueueItem #{operation.titleize}",
        resource: "NotificationQueueItem",
        operation: operation)
      system_role.system_permissions << permission
    end
    auth_system_group.system_roles << system_role
    auth_system_group.users << user

    login_as(user, scope: :user)
  end

  describe "index page" do
    let!(:topic) { create(:notification_topic) }
    let!(:message) { create(:notification_message, notification_topic: topic, subject: "Test Message") }
    let!(:subscriber) { create(:user) }
    let!(:subscription) { create(:notification_subscription, notification_topic: topic, user: subscriber) }
    let!(:queue_item) { create(:notification_queue_item, notification_message: message, notification_subscription: subscription, user: subscriber) }

    it "displays a list of notification queue items" do
      visit "/admin/notification_queue_items"

      expect(page).to have_content("Notification Queue Items")
      expect(page).to have_content(/email/i)
    end
  end

  describe "show page" do
    let!(:topic) { create(:notification_topic) }
    let!(:message) { create(:notification_message, notification_topic: topic, subject: "Queue Test Message") }
    let!(:subscriber) { create(:user, first_name: "Queue", last_name: "Subscriber") }
    let!(:subscription) { create(:notification_subscription, notification_topic: topic, user: subscriber) }
    let!(:target_queue_item) { create(:notification_queue_item, notification_message: message, notification_subscription: subscription, user: subscriber) }

    it "displays notification queue item details" do
      visit "/admin/notification_queue_items/#{target_queue_item.id}"

      expect(page).to have_content("Queue Test Message")
    end
  end
end
