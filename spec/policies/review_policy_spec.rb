# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ReviewPolicy, type: :policy) do
  subject { described_class }

  let(:audience_user) { build(:user, role: 'audience') }
  let(:admin_user) { build(:user) }
  let(:movie) { build(:movie) }

  shared_examples 'grants access to audience and admin users' do
    it { expect(subject).to(permit(audience_user, movie)) }
  end

  shared_examples 'denies access to audience and admin users' do
    it { expect(subject).not_to(permit(audience_user, movie)) }
  end

  permissions :index? do
    include_examples 'grants access to audience and admin users'
  end

  permissions :create? do
    context 'when the user is an audience user' do
      before { movie.user = audience_user }

      it 'allows the audience user to add review to a movie' do
        expect(subject).to(permit(audience_user, movie))
      end
    end

    context 'when the user is an admin user' do
      it 'denies the admin user to add review to a movie' do
        expect(subject).not_to(permit(admin_user, movie))
      end
    end
  end
end
