require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }  # -> somente cria quando for instanciado
  # let!(:user) { build(:user) } -> força a criação do objeto

  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('severo.fabricio@gmail.com').for(:email) }
  it { is_expected.to validate_confirmation_of(:password) }
end


