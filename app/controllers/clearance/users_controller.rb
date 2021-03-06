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
      Meter.create(id:(3*current_user.id-2),value:Random.rand(19000...20000),type_id:1,user_id:current_user.id,valueStartMonth:Random.rand(18000...19000))
      Meter.create(id:(3*current_user.id-1),value:Random.rand(29000...30000),type_id:2,user_id:current_user.id,valueStartMonth:Random.rand(28000...29000))
      Meter.create(id:(3*current_user.id),value:Random.rand(39000...40000),type_id:3,user_id:current_user.id,valueStartMonth:Random.rand(38000...39000))
      Limite.create(id:(3*current_user.id-2),value:Random.rand(30...100),meter_id:(3*current_user.id-2))
      Limite.create(id:(3*current_user.id-1),value:Random.rand(30...100),meter_id:(3*current_user.id-1))
      Limite.create(id:(3*current_user.id),value:Random.rand(30...100),meter_id:(3*current_user.id))
      d = Date.new(2017,05,01)
      while d.day<31 do
        Consumption.create(value:Random.rand(1...50),date:d,meter_id:(3*current_user.id-2))
        d=Date.new(2017,05,((d.day)+1))
      end
      e = Date.new(2017,05,01)
      while e.day<31 do
        Consumption.create(value:Random.rand(1...50),date:e,meter_id:(3*current_user.id-1))
        e=Date.new(2017,05,((e.day)+1))
      end
      f = Date.new(2017,05,01)
      while f.day<31 do
        Consumption.create(value:Random.rand(1...50),date:f,meter_id:(3*current_user.id))
        f=Date.new(2017,05,((f.day)+1))
      end

      d = Date.new(2017,06,01)
      f = Date.today
      while d.day<f.day do
        Consumption.create(value:Random.rand(1...50),date:d,meter_id:(3*current_user.id-2))
        d=Date.new(2017,06,((d.day)+1))
      end
      while d.day<30
        Consumption.create(value:0,date:d,meter_id:(3*current_user.id-2))
        d=Date.new(2017,06,((d.day)+1))
      end
      Consumption.create(value:0,date:d,meter_id:(3*current_user.id-2))
      d = Date.new(2017,06,01)
      while d.day<f.day do
        Consumption.create(value:Random.rand(1...50),date:d,meter_id:(3*current_user.id-1))
        d=Date.new(2017,06,((d.day)+1))
      end
      while d.day<30
        Consumption.create(value:0,date:d,meter_id:(3*current_user.id-1))
        d=Date.new(2017,06,((d.day)+1))
      end
      Consumption.create(value:0,date:d,meter_id:(3*current_user.id-1))
      d = Date.new(2017,06,01)
      while d.day<f.day do
        Consumption.create(value:Random.rand(1...50),date:d,meter_id:(3*current_user.id))
        d=Date.new(2017,06,((d.day)+1))
      end
      while d.day<30
        Consumption.create(value:0,date:d,meter_id:(3*current_user.id))
        d=Date.new(2017,06,((d.day)+1))
      end
      Consumption.create(value:0,date:d,meter_id:(3*current_user.id))
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
