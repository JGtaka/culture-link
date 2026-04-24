require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#page_title' do
    let(:site_name) { I18n.t('site_name') }

    context 'ページタイトルが指定されている場合' do
      it '"ページ名 | サイト名" 形式で返す' do
        expect(helper.page_title('ダッシュボード')).to eq("ダッシュボード | #{site_name}")
      end
    end

    context 'ページタイトルが空文字の場合' do
      it 'サイト名のみを返す' do
        expect(helper.page_title('')).to eq(site_name)
      end
    end

    context 'ページタイトルがnilの場合' do
      it 'サイト名のみを返す' do
        expect(helper.page_title(nil)).to eq(site_name)
      end
    end

    context '引数なしで呼ばれた場合' do
      it 'provide(:title)の値を使用する' do
        helper.provide(:title, 'マイページ')
        expect(helper.page_title).to eq("マイページ | #{site_name}")
      end

      it 'provide(:title)が未設定ならサイト名のみを返す' do
        expect(helper.page_title).to eq(site_name)
      end
    end

    context 'I18n.site_nameが "culture-link" の場合' do
      it 'サイト名を I18n から参照する' do
        expect(I18n.t('site_name')).to eq('culture-link')
        expect(helper.page_title('テスト')).to eq('テスト | culture-link')
      end
    end
  end
end
