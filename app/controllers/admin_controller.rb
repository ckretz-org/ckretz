# frozen_string_literal: true

class AdminController < ApplicationController
  http_basic_authenticate_with name: ENV.fetch('ADMIN_USERNAME', 'admin'), password:  ENV.fetch('ADMIN_PASSWORD', 'password')
end