require 'spec_helper'

module Bible
  describe Abbreviation do
    describe '.shorten' do
      it 'shortens Luke' do
        expect(Abbreviation.shorten 'Luke').to eq 'Lk'
      end
    end

    describe '.lengthen' do
      it 'lengthens book' do
        expect(Abbreviation.lengthen 'lu').to eq({ book: "Luke", chapter: '1', verse: '1' })
      end
      it 'lengthens book and chapter' do
        expect(Abbreviation.lengthen 'lu1').to eq({ book: "Luke", chapter: '1', verse: '1' })
      end
      it 'lengthens book, chapter and verse' do
        expect(Abbreviation.lengthen 'lu2:5').to eq({ book: "Luke", chapter: '2', verse: '5' })
      end
      it 'lengthens verse' do
        expect(Abbreviation.lengthen '15').to eq({ book: nil, chapter: nil, verse: '15' })
      end
    end
  end
end
