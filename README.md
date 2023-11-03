# README

Usando: Ruby 3.2.2, Rails 7.1.1
  
  Login de usuário gerado pelo Devise, posteriormente acrescentado o campo 'type'.
  
  Criadas duas subclasses de User: Owner e Customer, associadas ao campo 'type' em User.

  home/index.html.erb deverá fazer a checagem do current_user.type para selecionar a exibição de acordo

  próximos passos: 
    
    . gerar os modelos de pousada, quarto e preços_especiais
    . selecionar em que condições as views desses modelos serão apresentadas ao usuário
    . finalizar a configuração do fluxo entre rotas