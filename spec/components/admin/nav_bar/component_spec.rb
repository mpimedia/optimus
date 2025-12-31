require 'rails_helper'

describe Admin::NavBar::Component, type: :component do
  include_context 'component_setup'

  let(:environment) { 'development' }
  let(:component) { described_class.new(environment: environment) }

  before do
    sign_in(user)
  end

  describe '#env_class_color' do
    subject { component.env_class_color }

    context 'when environment is development' do
      let(:environment) { 'development' }

      it { is_expected.to eq 'bg-primary' }
    end

    context 'when environment is staging' do
      let(:environment) { 'staging' }

      it { is_expected.to eq 'bg-danger' }
    end

    context 'when environment is production' do
      let(:environment) { 'production' }

      it { is_expected.to eq 'bg-secondary' }
    end

    context 'when environment is unknown' do
      let(:environment) { 'unknown' }

      it { is_expected.to eq 'bg-secondary' }
    end
  end

  describe 'nav_items' do
    let(:environment) { 'development' }
    let(:component) { described_class.new(environment: environment) }

    it 'renders multiple nav items' do
      render_inline(component)

      expect(page).to have_text('Garden')
      expect(page).to have_text('Websites')
    end
  end
end
