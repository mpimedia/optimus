require 'rails_helper'

describe Admin::ArchivedBadge::Component, type: :component do
  it 'renders if instance archived_at attribute has a value' do
    link = create(:link, archived_at: Time.zone.now)
    component = described_class.new(archived_at: link.archived_at)
    render_inline(component)

    expect(page).to have_text('Archived')
  end

  it 'does not render if instance archived_at attribute is nil' do
    link = create(:link, archived_at: nil)
    component = described_class.new(archived_at: link.archived_at)
    render_inline(component)

    expect(page).to_not have_text('Archived')
  end
end
