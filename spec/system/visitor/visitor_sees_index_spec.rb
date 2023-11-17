require 'rails_helper'

describe '::Visitante acessa o site' do
  before(:each) do
    6.times do
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
    expect(current_path).to eq(root_path)
    expect(page).to have_content('POUSADARIA')
    within('#featured') do
      expect(page).to have_content(Inn.all[@count - 1].brand_name)
      expect(page).to have_content(Inn.all[@count - 2].brand_name)
      expect(page).to have_content(Inn.all[@count - 3].brand_name)
      expect(page).not_to have_content(Inn.all[@count - 4].brand_name)
    end
  end

  it 'e as pousadas antigas' do
    # Arrange
    # Act
    # Assert
    within('#all') do
      expect(page).to have_content(Inn.all[@count - 4].brand_name)
      expect(page).to have_content(Inn.all[@count - 5].brand_name)
      expect(page).to have_content(Inn.all[@count - 6].brand_name)
    end
  end
end
