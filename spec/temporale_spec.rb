require_relative 'spec_helper'

RSpec.describe COCC::Temporale do
  let(:year) { 2000 }
  let(:temporale) { described_class.new(year) }

  describe 'expected behaviour' do
    # just some smoke tests
    it 'has a celebration for every day in a year' do
      temporale.date_range.each do |date|
        expect(temporale[date]).to be_a COCC::Celebration
      end
    end

    describe 'it creates celebrations of all main kinds' do
      %w(ferial sunday feast solemnity).each do |rank|
        it rank do
          predicate = (rank + '?').to_sym
          expect(temporale.each_day.find {|date,celebration| celebration.public_send predicate })
            .not_to be nil
        end
      end
    end

    describe 'it does not inherit unwanted celebrations' do
      # celebrations generated by the Roman Temporale but
      # not present in the Old Catholic calendar
      %i(mother_of_church immaculate_heart).each do |symbol|
        it symbol do
          date = CR::Temporale::Dates.public_send symbol, year

          expect(temporale[date].symbol).not_to be symbol
        end
      end
    end
  end
end