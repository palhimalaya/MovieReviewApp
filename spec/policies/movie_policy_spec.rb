# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MoviePolicy, type: :policy) do
  subject { described_class }

  let(:admin_user) { build(:user) }
  let(:audience_user) { build(:user, role: 'audience') }
  let(:movie) { build(:movie) }

  shared_examples 'grants access to audience and admin users' do
    it { expect(subject).to(permit(admin_user, movie)) }
  end

  shared_examples 'denies access to audience and admin users' do
    it { expect(subject).not_to(permit(admin_user, movie)) }
  end

  permissions :show? do
    include_examples 'grants access to audience and admin users'
  end

  permissions :index? do
    include_examples 'grants access to audience and admin users'
  end

  permissions :create?, :update?, :destroy? do
    context 'when the user is the owner of the movie' do
      before { movie.user = admin_user }

      it 'grants access to the movie' do
        expect(subject).to(permit(admin_user, movie))
      end
    end

    context 'when the user is not the owner of the movie' do
      it 'denies access to the movie' do
        expect(subject).not_to(permit(audience_user, movie))
      end
    end
  end
end
