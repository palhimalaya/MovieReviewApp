# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Movie, type: :model) do
  let(:movie) { build(:movie) }

  it 'validates presence of title' do
    expect(movie).to(validate_presence_of(:title))
  end

  it 'validates presence of release date' do
    expect(movie).to(validate_presence_of(:release_date))
  end

  it 'validates presence of duration' do
    expect(movie).to(validate_presence_of(:duration))
  end
end
