require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'バリデーション' do
    it '全ての属性が正しければ有効であること' do
      event = build(:event)
      expect(event).to be_valid
    end

    it 'titleがなければ無効であること' do
      event = build(:event, title: nil)
      expect(event).not_to be_valid
    end

    it 'yearがなければ無効であること' do
      event = build(:event, year: nil)
      expect(event).not_to be_valid
    end

    it 'descriptionがなければ無効であること' do
      event = build(:event, description: nil)
      expect(event).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'periodに属すること' do
      association = described_class.reflect_on_association(:period)
      expect(association.macro).to eq :belongs_to
    end

    it 'categoryに属すること' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq :belongs_to
    end

    it 'study_unitに属すること' do
      association = described_class.reflect_on_association(:study_unit)
      expect(association.macro).to eq :belongs_to
    end

    it 'regionに属すること' do
      association = described_class.reflect_on_association(:region)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のevent_charactersを持つこと' do
      association = described_class.reflect_on_association(:event_characters)
      expect(association.macro).to eq :has_many
    end

    it '複数のcharactersをevent_characters経由で持つこと' do
      association = described_class.reflect_on_association(:characters)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :event_characters
    end
  end

  describe 'スコープ' do
    let!(:period_a) { create(:period, name: '飛鳥時代') }
    let!(:period_b) { create(:period, name: '奈良時代') }
    let!(:region_a) { create(:region, name: '近畿') }
    let!(:region_b) { create(:region, name: '関東') }
    let!(:category_a) { create(:category, name: '政治') }
    let!(:category_b) { create(:category, name: '文化') }

    let!(:event_a) { create(:event, period: period_a, region: region_a, category: category_a) }
    let!(:event_b) { create(:event, period: period_b, region: region_b, category: category_b) }

    describe '.by_period' do
      it '指定したperiod_idのeventだけ返すこと' do
        expect(Event.by_period(period_a.id)).to contain_exactly(event_a)
      end

      it 'period_idが空なら全件返すこと' do
        expect(Event.by_period(nil)).to contain_exactly(event_a, event_b)
        expect(Event.by_period('')).to contain_exactly(event_a, event_b)
      end
    end

    describe '.by_region' do
      it '指定したregion_idのeventだけ返すこと' do
        expect(Event.by_region(region_a.id)).to contain_exactly(event_a)
      end

      it 'region_idが空なら全件返すこと' do
        expect(Event.by_region(nil)).to contain_exactly(event_a, event_b)
        expect(Event.by_region('')).to contain_exactly(event_a, event_b)
      end
    end

    describe '.by_category' do
      it '指定したcategory_idのeventだけ返すこと' do
        expect(Event.by_category(category_a.id)).to contain_exactly(event_a)
      end

      it 'category_idが空なら全件返すこと' do
        expect(Event.by_category(nil)).to contain_exactly(event_a, event_b)
        expect(Event.by_category('')).to contain_exactly(event_a, event_b)
      end
    end

    describe 'スコープのチェーン' do
      it '複数条件で絞り込めること' do
        event_c = create(:event, period: period_a, region: region_b, category: category_a)
        expect(Event.by_period(period_a.id).by_region(region_a.id)).to contain_exactly(event_a)
        expect(Event.by_period(period_a.id)).to contain_exactly(event_a, event_c)
      end
    end
  end
end
