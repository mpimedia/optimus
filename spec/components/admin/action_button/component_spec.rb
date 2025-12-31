require 'rails_helper'

describe Admin::ActionButton::Component, type: :component do
  include_context 'component_setup'

  describe '#render' do
    let(:link) { create(:link) }

    before do
      sign_in(user)
    end

    it 'renders a cancel_to_index action button' do
      component = described_class.new(operation: :cancel_to_index, instance: link, public: true)
      render_inline(component)

      expect(page).to have_text('Cancel')
      expect(page).to have_link(nil, href: '/admin/links')
      expect(page).to have_css('.btn-secondary')
      expect(page).to have_css('.bi-x-octagon')

      link = page.find('a', text: 'Cancel')
      method_attribute = link['data-turbo-method']

      expect(method_attribute).to eq('get')
    end

    it 'renders a cancel_to_show action button' do
      component = described_class.new(operation: :cancel_to_show, instance: link, public: true)
      render_inline(component)

      expect(page).to have_text('Cancel')
    end
  end
end
