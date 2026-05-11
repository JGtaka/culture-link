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

  describe '#render_markdown' do
    context 'マークダウン記法が含まれる場合' do
      it '太字を <strong> に変換する' do
        expect(helper.render_markdown('**強調**')).to include('<strong>強調</strong>')
      end

      it '見出し(##)を <h2> に変換する' do
        expect(helper.render_markdown('## 見出し')).to include('<h2>見出し</h2>')
      end

      it 'リスト記法を <ul><li> に変換する' do
        result = helper.render_markdown("- りんご\n- みかん")
        expect(result).to include('<ul>')
        expect(result).to include('<li>りんご</li>')
        expect(result).to include('<li>みかん</li>')
      end

      it 'リンク記法を <a> に変換する' do
        result = helper.render_markdown('[リンク](https://example.com)')
        expect(result).to include('href="https://example.com"')
        expect(result).to include('>リンク</a>')
      end

      it 'リンクに target="_blank" と rel が付与される (別タブで開く)' do
        result = helper.render_markdown('[リンク](https://example.com)')
        expect(result).to include('target="_blank"')
        expect(result).to include('rel="noopener noreferrer"')
      end

      it '結果はhtml_safeである' do
        expect(helper.render_markdown('普通の文章')).to be_html_safe
      end
    end

    context '改行の扱い' do
      it '単一改行(\n)を <br> に変換する (hard wrap)' do
        result = helper.render_markdown("一行目\n二行目")
        expect(result).to include('<br>')
        expect(result).to include('一行目')
        expect(result).to include('二行目')
      end

      it '空行を挟むと別の段落 <p> として扱う' do
        result = helper.render_markdown("段落1\n\n段落2")
        # 2つの <p> タグが生成される
        expect(result.scan('<p>').size).to eq(2)
        expect(result).to include('段落1')
        expect(result).to include('段落2')
      end

      it '連続した改行(3行)も段落区切りとして扱える' do
        result = helper.render_markdown("段落A\n\n段落B\n\n段落C")
        expect(result.scan('<p>').size).to eq(3)
      end

      it '段落内の単一改行は <br> で繋ぐ' do
        result = helper.render_markdown("行1\n行2\n\n別段落")
        expect(result).to include('<br>')
        expect(result.scan('<p>').size).to eq(2)
      end
    end

    context 'XSS対策' do
      it '<script>タグを除去する' do
        result = helper.render_markdown('hello<script>alert(1)</script>world')
        expect(result).not_to include('<script>')
        expect(result).not_to include('alert(1)')
      end

      it 'onerror属性を除去する' do
        result = helper.render_markdown('<img src=x onerror="alert(1)">')
        expect(result).not_to include('onerror')
      end

      it 'javascript:スキームのリンクを除去する' do
        result = helper.render_markdown('[クリック](javascript:alert(1))')
        expect(result).not_to include('javascript:')
      end
    end

    context '入力が空またはnilの場合' do
      it 'nilでも空文字を返す' do
        expect(helper.render_markdown(nil)).to eq('')
      end

      it '空文字なら空文字を返す' do
        expect(helper.render_markdown('')).to eq('')
      end
    end
  end

  describe '#markdown_to_plain' do
    context 'マークダウン記号を取り除く' do
      it '太字記号(**)を除去する' do
        expect(helper.markdown_to_plain('**強調**された文')).to eq('強調された文')
      end

      it '見出し記号(##)を除去する' do
        expect(helper.markdown_to_plain('## 見出し')).to eq('見出し')
      end

      it 'リスト記号(-)を除去する' do
        result = helper.markdown_to_plain("- りんご\n- みかん")
        expect(result).not_to include('-')
        expect(result).to include('りんご')
        expect(result).to include('みかん')
      end

      it 'リンク記法は表示テキストのみ残す' do
        expect(helper.markdown_to_plain('[公式サイト](https://example.com)を見る')).to eq('公式サイトを見る')
      end
    end

    context 'HTMLタグを取り除く' do
      it '<strong>などのHTMLタグも除去する' do
        expect(helper.markdown_to_plain('普通の<strong>太字</strong>文')).to eq('普通の太字文')
      end

      it '<script>タグの中身も除去する' do
        result = helper.markdown_to_plain('hello<script>alert(1)</script>world')
        expect(result).not_to include('alert(1)')
        expect(result).not_to include('<script>')
      end
    end

    context '入力が空またはnilの場合' do
      it 'nilでも空文字を返す' do
        expect(helper.markdown_to_plain(nil)).to eq('')
      end

      it '空文字なら空文字を返す' do
        expect(helper.markdown_to_plain('')).to eq('')
      end
    end
  end
end
