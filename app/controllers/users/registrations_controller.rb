class Users::RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    params.delete(:current_password)
    resource.update(params)
  end

  def after_update_path_for(resource)
    profile_path
  end
end
