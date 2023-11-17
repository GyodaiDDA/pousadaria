require 'rails_helper'

describe '::Editar Pousada' do
  before(:each) do
    @owner = make_owner
    @inn = make_inn(@owner)
    @room = make_room(@inn)
  end
  context 'sem ser o dono' do
    it 'GET edit_inn_path' do
      get edit_inn_path(@room.id)
      expect(response).to redirect_to(root_path)
    end
  end
end
