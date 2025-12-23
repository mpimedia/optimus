class AccountSecurityController < ApplicationController
  before_action -> { rodauth.require_account }

  def show
  end
end
