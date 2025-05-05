class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    case resource.role
    when "admin"
      admin_users_path
    when "token_operator"
      new_token_path
    when "counter_incharge"
      live_tokens_path
    else
      root_path
    end
  end
end
