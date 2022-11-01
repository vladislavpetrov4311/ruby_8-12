ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors, with: :threads)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  # Возвращает true, если тестовый пользователь осуществил вход.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Осуществляет вход тестового пользователя
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '0'
    if integration_test?
      post 'http://127.0.0.1:3000/login', params: { session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me } }
    else
      session[:user_id] = user.id
    end
  end

  # Возвращает true внутри интеграционных тестов
  def integration_test?
    defined?(follow_redirect!)
  end
end
