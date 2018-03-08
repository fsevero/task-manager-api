require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }  # -> somente cria quando for instanciado
  # let!(:user) { build(:user) } -> força a criação do objeto

  it { is_expected.to have_many(:tasks).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive.scoped_to(:provider) }
  it { is_expected.to allow_value('severo.fabricio@gmail.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'return email, created_at and Token' do
      user.save!
      allow(Devise).to receive(:friendly_token).and_return('abcde12345')

      expect(user.info).to eq("#{user.email} - #{user.created_at} - Token: abcde12345")
    end
  end

  describe '#generate_authentication_token!' do
    it 'generates an unique auth token' do
      allow(Devise).to receive(:friendly_token).and_return('abcde12345')
      user.generate_authentication_token!

      expect(user.auth_token).to eq('abcde12345')
    end

    it 'generates another token when the current auth token already has been taken' do
      allow(Devise).to receive(:friendly_token).and_return('12345abcdef', '12345abcdef', '1234567890abc')
      existing_user = create(:user)
      user.generate_authentication_token!

      expect(user.auth_token).not_to eq(existing_user.auth_token)
    end

  end

end


