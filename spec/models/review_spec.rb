# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Review, type: :model) do
  let(:user) { build(:user) }
  let(:movie) { build(:movie) }
  let(:review) { build(:review, user: user, movie: movie) }

  describe 'validations' do
    it { is_expected.to(validate_presence_of(:rating)) }
    it { is_expected.to(validate_presence_of(:review)) }

    it 'ensures rating is between 1 and 10' do
      expect(review).to(be_valid)

      review.rating = 1
      expect(review).to(be_valid)

      review.rating = 10
      expect(review).to(be_valid)

      review.rating = 0
      expect(review).not_to(be_valid)

      review.rating = 11
      expect(review).not_to(be_valid)
    end
  end
end
