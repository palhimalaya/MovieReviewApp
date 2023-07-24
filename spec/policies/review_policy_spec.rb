# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(ReviewPolicy, type: :policy) do
  subject { described_class }

  let(:audience_user) { build(:user, role: 'audience') }
  let(:admin_user) { build(:user) }
  let(:movie) { build(:movie) }

  shared_examples 'grants access to any user' do
    it 'grants access' do
      expect(subject).to(permit(audience_user, movie))
    end
  end

  shared_examples 'denies access to any user' do
    it 'denies access' do
      expect(subject).not_to(permit(audience_user, movie))
    end
  end

  permissions :index? do
    include_examples 'grants access to any user'
  end

  permissions :create? do
    context 'when the user is the Audience' do
      before { movie.user = audience_user }

      it 'grants access' do
        expect(subject).to(permit(audience_user, movie))
      end
    end

    context 'when the user is Admin' do
      it 'denies access' do
        expect(subject).not_to(permit(admin_user, movie))
      end
    end
  end
end
