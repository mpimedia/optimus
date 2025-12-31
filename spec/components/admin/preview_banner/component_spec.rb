# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PreviewBanner::Component, type: :component do
  let(:resource) { create(:landing_page, name: 'Devs Die Slowly') }

  it 'renders a message with the name of the resource' do
    render_inline(Admin::PreviewBanner::Component.new(resource: resource))
    expect(page).to have_content("You're looking at a preview of Devs Die Slowly")
  end

  it 'renders a link to the live URL of the resource is published' do
    create(:domain_name, domainable: resource, domain: 'devsdieslowly.com')
    resource.update!(published: true)

    render_inline(Admin::PreviewBanner::Component.new(resource: resource))
    expect(page).to have_content('You can view it live at')
    expect(page).to have_link(resource.live_url, href: resource.live_url)
  end

  it 'renders a message indicating the resource is not published if it is not published' do
    render_inline(Admin::PreviewBanner::Component.new(resource: resource))
    expect(page).to have_content('This page has not been published yet.')
  end

  it 'renders a link back to the admin resource index page' do
    render_inline(Admin::PreviewBanner::Component.new(resource: resource))
    expect(page).to have_link('Back to Admin', href: '/admin/landing_pages')
  end
end
