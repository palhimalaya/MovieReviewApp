# frozen_string_literal: true

require 'rails_helper'

RSpec.describe(Movies::Find) do
  subject { described_class }

  let!(:user1) { create(:user, password: 'P@ssw0rd1') }

  let!(:movie1) { create(:movie, user: user1, title: 'The Matrix', release_date: '1999-03-31') }
  let!(:movie2) { create(:movie, user: user1, title: 'Inception', release_date: '2010-07-16') }
  let!(:movie3) { create(:movie, user: user1, title: 'Interstellar', release_date: '2014-11-05') }

  describe '#execute' do
    let(:scope) { Movie.all }

    it 'returns the original scope if no search_query and sort_by are provided' do
      params = {}
      finder = subject.new(scope, params)

      result = finder.execute

      expect(result).to(eq(scope))
    end

    it 'filters movies by search_query' do
      params = { search: 'Inception' }
      finder = subject.new(scope, params)

      result = finder.execute

      expect(result).to(contain_exactly(movie2))
    end

    it 'ignores case sensitivity when filtering movies by search_query' do
      params = { search: 'matrix' }
      finder = subject.new(scope, params)

      result = finder.execute

      expect(result).to(contain_exactly(movie1))
    end

    it 'sorts movies by release_date in ascending order' do
      params = { order: 'asc' }
      finder = subject.new(scope, params)

      result = finder.execute

      expect(result).to(eq([movie1, movie2, movie3]))
    end

    it 'sorts movies by release_date in descending order' do
      params = { order: 'desc' }
      finder = subject.new(scope, params)

      result = finder.execute

      expect(result).to(eq([movie3, movie2, movie1]))
    end
  end
end
