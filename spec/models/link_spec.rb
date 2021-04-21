require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#gist?' do
    let!(:gist_url) { create(:link, url: 'https://gist.github.com/PapaKramb/e8943bcca0e3c40c399d6656a19c522e', linkable: question) }
    let!(:link) { create(:link, linkable: question) }

    it 'true if links to gist' do
      expect(gist_url.gist?).to be_truthy
    end

    it 'false if not links to gist' do
      expect(link.gist?).to be_falsey
    end
  end
end
