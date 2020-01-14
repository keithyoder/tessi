ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => 'tessi.com.br',
    :user_name            => 'yoder@tessi.com.br',
    :password             => 'Fusca1977',
    :authentication       => 'plain',
    :enable_starttls_auto => true  }
