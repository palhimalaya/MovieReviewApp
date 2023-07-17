# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(MoviePolicy, type: :policy) do
  subject { described_class }

  let(:user) { build(:user) }
  let(:other_user) { build(:user, role: 'audience') }
  let(:movie) { build(:movie) }

  shared_examples 'grants access to any user' do
    it 'grants access' do
      expect(subject).to(permit(user, movie))
    end
  end

  shared_examples 'denies access to any user' do
    it 'denies access' do
      expect(subject).not_to(permit(user, movie))
    end
  end

  permissions :show? do
    include_examples 'grants access to any user'
  end

  permissions :index? do
    include_examples 'grants access to any user'
  end

  permissions :create?, :update?, :destroy? do
    context 'when the user is the owner of the movie' do
      before { movie.user = user }

      it 'grants access' do
        expect(subject).to(permit(user, movie))
      end
    end

    context 'when the user is not the owner of the movie' do
      it 'denies access' do
        expect(subject).not_to(permit(other_user, movie))
      end
    end
  end
end
