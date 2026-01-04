require 'rails_helper'
describe Admin::SystemGroupsController, type: :controller do
  login_user

  context 'when authenticated and authorized' do
    before do
      allow_any_instance_of(described_class).to receive(:authorize).and_return(true)
    end

    it 'responds successfully to index' do
      get :index

      expect(response).to have_http_status(:ok)
    end

    it 'responds successfully to show' do
      system_group = create(:system_group)
      get :show, params: { id: system_group.id }

      expect(response).to have_http_status(:ok)
    end

    it 'responds successfully to new' do
      get :new

      expect(response).to have_http_status(:ok)
    end

    it 'responds successfully to edit' do
      system_group = create(:system_group)
      get :edit, params: { id: system_group.id }

      expect(response).to have_http_status(:ok)
    end

    it 'creates a system_group and redirects' do
      system_group_params = {
        name: 'Test Group',
        abbreviation: 'TG',
        description: 'Test Description',
        notes: 'Test Notes'
      }

      expect {
        post :create, params: { system_group: system_group_params }
      }.to change(SystemGroup, :count).by(1)

      expect(response).to have_http_status(:redirect)
      expect(flash[:success]).to be_present
    end

    it 'updates a system_group and redirects' do
      system_group = create(:system_group)
      updated_params = { name: 'Updated Group' }

      patch :update, params: { id: system_group.id, system_group: updated_params }

      expect(response).to have_http_status(:redirect)
      expect(flash[:success]).to be_present
      expect(system_group.reload.name).to eq('Updated Group')
    end

    it 'destroys a system_group and redirects' do
      system_group = create(:system_group)

      expect {
        delete :destroy, params: { id: system_group.id }
      }.to change(SystemGroup, :count).by(-1)

      expect(response).to have_http_status(:redirect)
      expect(flash[:danger]).to be_present
    end
  end

  context 'when not authenticated' do
    before { sign_out @current_user }

    it 'redirects to sign in for index' do
      get :index

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for show' do
      system_group = create(:system_group)
      get :show, params: { id: system_group.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for new' do
      get :new

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for edit' do
      system_group = create(:system_group)
      get :edit, params: { id: system_group.id }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for create' do
      post :create, params: { system_group: { name: 'Test Group' } }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for update' do
      system_group = create(:system_group)
      patch :update, params: { id: system_group.id, system_group: { name: 'Updated' } }

      expect(response).to redirect_to(new_user_session_path)
    end

    it 'redirects to sign in for destroy' do
      system_group = create(:system_group)
      delete :destroy, params: { id: system_group.id }

      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when authenticated but unauthorized' do
    it 'returns unauthorized status via the Pundit handler for index' do
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      get :index

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for show' do
      system_group = create(:system_group)
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      get :show, params: { id: system_group.id }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for new' do
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      get :new

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for edit' do
      system_group = create(:system_group)
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      get :edit, params: { id: system_group.id }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for create' do
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      post :create, params: { system_group: { name: 'Test Group' } }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for update' do
      system_group = create(:system_group)
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      patch :update, params: { id: system_group.id, system_group: { name: 'Updated' } }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end

    it 'returns unauthorized status via the Pundit handler for destroy' do
      system_group = create(:system_group)
      allow_any_instance_of(described_class).to receive(:authorize).and_raise(Pundit::NotAuthorizedError)
      allow_any_instance_of(ApplicationController).to receive(:user_not_authorized) do |controller, _exception|
        controller.render(plain: 'unauthorized', status: :unauthorized)
      end

      delete :destroy, params: { id: system_group.id }

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to include('unauthorized')
    end
  end
end
