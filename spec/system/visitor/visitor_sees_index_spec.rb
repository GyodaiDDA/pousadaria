require 'rails_helper'

describe '::Visitante acessa o site' do
  before(:each) do
    4.times do
      @owner = make_owner
      @inn = make_inn(@owner)
    end
    @count = Inn.all.size
    visit root_path
  end

  it 'e vê as pousadas mais recentes' do
    # Arrange
    # Act
    # Assert
    expect(@count).to eq 4
    expect(current_path).to eq(root_path)
    expect(page).to have_content('POUSADARIA')
    within('#featured') do
      expect(page).to have_content(Inn.all[3].brand_name)
      expect(page).to have_content(Inn.all[2].brand_name)
      expect(page).to have_content(Inn.all[1].brand_name)
      expect(page).not_to have_content(Inn.all[0].brand_name)
    end
  end

  it 'e as pousadas antigas' do
    # Arrange
    # Act
    # Assert
    within('#all') do
      expect(page).to have_content(Inn.all[0].brand_name)
      expect(page).to have_content(Inn.all[0].city)
    end
  end
end
