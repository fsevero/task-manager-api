require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }  # -> somente cria quando for instanciado
  # let!(:user) { build(:user) } -> força a criação do objeto

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('severo.fabricio@gmail.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }

  describe '#info' do
    it 'return email and created_at' do
      user.save!

      expect(user.info).to eq("#{user.email} - #{user.created_at}")
    end
  end

end


