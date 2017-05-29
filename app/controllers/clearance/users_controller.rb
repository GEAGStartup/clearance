class Clearance::UsersController < Clearance::BaseController
  if respond_to?(:before_action)
    before_action :redirect_signed_in_users, only: [:create, :new]
    skip_before_action :require_login, only: [:create, :new], raise: false
    skip_before_action :authorize, only: [:create, :new], raise: false
  else
    before_filter :redirect_signed_in_users, only: [:create, :new]
    skip_before_filter :require_login, only: [:create, :new], raise: false
    skip_before_filter :authorize, only: [:create, :new], raise: false
  end

  def new
    @user = user_from_params
    render template: "users/new"
  end

  def create
    @user = user_from_params

    if @user.save
      sign_in @user
      redirect_back_or url_after_create
      Meter.create(id:(3*current_user.id-2),value:10000,type_id:1,user_id:current_user.id,valueStartMonth:9000)
      Meter.create(id:(3*current_user.id-1),value:15000,type_id:2,user_id:current_user.id,valueStartMonth:14500)
      Meter.create(id:(3*current_user.id),value:20000,type_id:3,user_id:current_user.id,valueStartMonth:19300)
      Limite.create(id:(3*current_user.id-2),value:50,meter_id:(3*current_user.id-2))
      Limite.create(id:(3*current_user.id-1),value:50,meter_id:(3*current_user.id-1))
      Limite.create(id:(3*current_user.id),value:50,meter_id:(3*current_user.id))
    else
      render template: "users/new"
    end
  end

  private

  def avoid_sign_in
    warn "[DEPRECATION] Clearance's `avoid_sign_in` before_filter is " +
      "deprecated. Use `redirect_signed_in_users` instead. " +
      "Be sure to update any instances of `skip_before_filter :avoid_sign_in`" +
      " or `skip_before_action :avoid_sign_in` as well"
    redirect_signed_in_users
  end

  def redirect_signed_in_users
    if signed_in?
      redirect_to Clearance.configuration.redirect_url
    end
  end

  def url_after_create
    Clearance.configuration.redirect_url
  end

  def user_from_params
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end

  def user_params
    params[Clearance.configuration.user_parameter] || Hash.new
  end
end
