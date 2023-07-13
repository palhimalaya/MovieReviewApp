# frozen_string_literal: true

require 'rake'
namespace :task_namespace do
  desc 'Send reminder email to users'
  task reminder_email: :environment do
    User.all.each do |user|
      UserMailer.confirmation_instructions(user, user.confirmation_token).deliver unless user.confirmed?
    end
  end
end
