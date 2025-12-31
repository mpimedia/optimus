require 'rails_helper'

describe Admin::NavDropdownItem::Component, type: :component do
  include_context 'component_setup'

  before do
    sign_in(user)
  end

  it 'renders a nav item dropdown item if the resource index policy allows it for the current user' do
    allow(Pundit).to receive(:policy).and_return(double('policy', index?: true))
    render_inline(described_class.new(name: 'Dropdown Item', path: '/dropdown_path', resource: User))
    expect(page).to have_css('li a.dropdown-item')
    expect(page).to have_link(text: 'Dropdown Item', href: '/dropdown_path')
  end

  it 'does not render the nav item dropdown item if the resource index policy does not allow it for the current user' do
    allow(Pundit).to receive(:policy).and_return(double('policy', index?: false))
    render_inline(described_class.new(name: 'Dropdown Item', path: '/dropdown_path', resource: User))
    expect(page).not_to have_css('li')
  end

  it 'renders the nav item dropdown item if no resource is provided' do
    render_inline(described_class.new(name: 'Dropdown Item', path: '/dropdown_path'))
    expect(page).to have_css('li a.dropdown-item')
    expect(page).to have_link(text: 'Dropdown Item', href: '/dropdown_path')
  end
end
