
## Pousadaria

  

***Models Entregues***

-  **user.rb:**

  - criado pelo *devise*, acrescentada a relação 1>1 entre usuários e pousadas

-  **inn.rb:**

  - estabelece relação 1:1 entre pousadas e usuários

  - estabelece relação 1:* entre pousadas e quartos

  - valida presença para nomes, cnpj, cidade, UF e CEP

  - valida unicidade e comprimento (14) de CNPJ

  - valida de acordo a regras da RF (ver validators/cnpj_validator.rb) 11/11/2023

-  **room.rb:**

  - estabelece relação *:1 entre quartos e pousadas

  - estabelece relação *:1 entre quartos e períodos

  - valida presença para nome, área, qtd hóspedes e preço base

-  **seasonal.rb**

  - estabelece relação *:1 entre quartos e períodos

  - valida presença para datas de início e término e preço especial

  - faz validações para checar se

    - (1) as datas sobrepões outras no mesmo quarto,

    - (2) a data de início precede a de término e

    - (3) se ambas as datas ainda estão por vir.

-  **owner.rb** e **customer.rb:** Permitem a criação de objetos específicos para cada tipo de usuário mas não acrescentam configuração extras

-  **reservation.rb**

  - estabelece relação *:1 entre reservas e quartos
  - estabelece relação *:1 entre reservas e usuários
  - faz validações para checar se

    - (1) as datas sobrepões outras no mesmo quarto,

    - (2) a data de início precede a de término e

    - (3) se ambas as datas ainda estão por vir.


***Controllers Entregues ou Alterados***

-  **application_controller.rb:**

  - adicionado método `set_locale` para resolver problemas com i18n
  - adicionado método `owners_only` para verificar se o usuário é um dono de pousada
  - adicionado método `the_owner?` para verificar se o usuário é dono da Pousada associada

-  **home_controller.rb:**

- método `index` que define `@active_inns` ,`new_inns` e `older_inss` para a view

-  **inns_controller.rb:**

  - métodos de recurso: `index` ,`show`, `new`, `create`, `edit`, `update`
  - métodos privados: `inn_exists?`, `set_inn`, `inn_params`, `set_rooms`

  - método customizados
	  - `cities` para exibir pousadas por cidade
	  - `search` para busca de pousadas

-  **rooms_controller.rb:**

  - métodos de recurso: `index`, `show`, `new`, `create`, `edit`, `update`
  - métodos privados: `set_room` e `room_params`, para definição de variáveis de quarto

-  **seasonals_controller.rb:**
  - métodos de recurso: `show`, `new`, `create`, `edit`, `update`, `index`
  - métodos privados: `set_seasonal`, `seasonal_params`, para definição de variáveis de período
  - método customizado: `set_room`,`room_seasonals`: busca lista de períodos no mesmo quarto

-  **registration_controller.rb**

  - método `configure_sign_up_params` para permitir a inclusão de `user_type` na criação de usuários
  - método `after_sign_up_path_for` para redirecionar donos de pousada a `new_inn_path` logo após o cadastro

-  **sessions_controller.rb**

  - método `after_sign_in_path_for` para redirecionar donos de pousada sem pousada à `new_inn_path`

-  **reservations_controller.rb**

  - métodos de recurso: `index` ,`show`, `new`, `create`
  - métodos privados: `set_reservation`, `set_room`, `consultation_params`

***Views e Navegação***

-  **Devise**

  -  */registrations/_owner.html.erb e */registrations/_customer.html.erb*: formulários de registro com envio de `user_type` pré-definido

-  **Layouts**
	-  *application.html.erb*: menu condicional (tipos de usuários e visitantes não logados)

-  **Owners**
	- *_submenu*

-  **Inns**
	-  *new*, *edit*, *show*, *cities*, *search*
	-  partials: *_errors*, *_form*, *_index*, *_list_all_inns* e *_list_new_inns*

-  **Rooms**
	-  *new*, *edit*, *show* e *index*
	-  partials: *_errors*, *_form*

-  **Seasonals**
	-  *new*
	- *_index*, *_errors*, *_form*

-  **Reservations**
	-  *new*, *show*
	-  partials: *_index*, *_consult_form*

***Routes***
  - Rotas de *seasonal* subordinadas em *rooms*
  - Rotas de *reservation* subordinadas em *rooms*
  - Redirecionamento direto para página de Pousadas por Cidade
  - Especificação dos modelos *registrations* e *sessions* para o `devise`
  - Rota para 'search' subordinada em *inns*

***CSS***
  - Criado arquivo assets/stylesheets/application.css para formatação mínima

***Acessos restritos***
  - O acesso à páginas de edição está restrito nas views, checando a variável `@owner_view` do método `is_owner?`

***Testes de Sistema***

- Automatização da criação de objetos, utilizando gem Faker no arquivo spec/support/fake.rb

- Owner > Pousada > Altera
	- Owner altera os dados da pousada com sucesso
	- Owner altera os dados da pousada e falha por validação de CNPJ
	- Owner altera os dados da pousada e falha por Razão Social vazia
- Owner > Pousada > Cria
	- Owner cadastra pousada com sucesso clicando em Cadastrar Pousada
	- Owner cadastra pousada com sucesso logo após criar sua conta.
	- Owner cadastra pousada e falha na validação de CNPJ
	- Owner cadastra pousada e falha por faltar Nome Fantasia
	- Owner cadastra pousada e visualiza clicando em Minha Pousada

- Owner > Quarto > Altera
	- Owner altera Quarto a partir da página de Pousada clicando em Editar
	- Owner altera Quarto a partir da página de Pousada com sucesso
	- Owner altera Quarto a partir da página de Pousada e falha por validação
	- Owner altera Quarto a partir da página de Quarto clicando em Editar Quarto
	- Owner altera Quarto a partir da página de Quarto com sucesso
	- Owner altera Quarto a partir da página de Quarto e falha por validação

- Owner > Quarto > Cria
	- Owner cadastra novo quarto clicando em Adicionar Quarto
	- Owner cadastra novo quarto com sucesso
	- Owner cadastra novo quarto e falha na validação de Área
 	- Owner cadastra novo quarto e falha por falta do nome

- Owner > Período > Cria
	- Owner cría novo Período clicando em Períodos Especiais
	- Owner cria novo Período e falha por sobreposição de data
	- Owner cria novo Período e falha por superação de data
	- Owner cria novo Período e falha por reversão de data
	- Owner cria novo Período com sucesso

- Owner > Signin
	- Owner clica no botão Entrar e vê a página de login
	- Owner clica no botão Entrar e falha ao fazer login
 	- Owner clica no botão Entrar e faz login com sucesso
 	- Owner clica no botão Entrar e é levado para criar Pousada

- Owner > Signup
	- Owner tenta criar uma nova conta mas email já está em uso como Customer
	- Owner cria uma nova conta mas email já está em uso como Owner
	- Owner cria uma nova conta mas falha na confirmação de senha
	- Owner cria nova conta e é levado para criar Pousada

- Visitante > Acesso
	- Visitante acessa o site e as pousadas antigas
	- Visitante acessa o site e vê as pousadas mais recentes
	- Visitante vê a página da Pousada com lista de quartos ativos

- Customer > Search
	- Customer busca por pousadas e recebe resultados
  

-------------------------
