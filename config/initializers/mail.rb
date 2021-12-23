# frozen_string_literal: true

ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'tessi.com.br',
  user_name: 'XXXXX',
  password: 'XXXXX',
  authentication: 'plain',
  enable_starttls_auto: true
}
