
## Pousadaria

***Models Entregues***

 - **user.rb:**
    -  criado pelo *devise*, acrescentada a relação 1>1 entre usuários e pousadas
    
- **inn.rb:** 
    - estabelece relação 1<1 entre pousadas e usuários
    - estabelece relação  1 > * entre pousadas e quartos
	- valida presença para nomes, cnpj, cidade, UF e CEP
	- valida unicidade e comprimento (14) de CNPJ (teste de validade deve ser melhorado)
- **room.rb:**
	-  estabelece relação 1<1 entre quartos e pousadas
	- valida presença para nome, área, qtd hóspedes e preço base
- **seasonal.rb**
	- estabelece relação 1< * entre quartos e períodos
	- valida presença para datas de início e término e preço especial
	- faz validação customizada acessando *validators/dates_validator.rb* que roda três métodos para checar se
		-  (1) as datas sobrepões outras no mesmo quarto,
		- (2) a data de início precede a de término e
		- (3) se ambas as datas ainda estão por vir.
- **owner.rb** e **customer.rb:** Permitem a criação de objetos específicos para cada tipo de usuário mas não acrescentam configuração extras (09-nov)

***Controllers Entregues ou Alterados***

- **application_controller.rb:**
	- adicionado método `set_locale` para resolver problemas com i18n **¹**
	- adicionado método `block_customer` para herança em outros controllers
  - adicionado método `check_ownership` para verificar se o usuário é dono da Pousada associada
- **home_controller.rb:**
	- método `index`
- **inns_controller.rb:**
	- métodos de recurso: `index` ,`show`, `new`, `create`, `edit`, `update`
	- métodos privados: `set_inn`, `inn_params`, para definição de variáveis de pousada
  - método customizado: `set_inn` agora chama `check_ownership`
	- outros métodos customizados:
		- `cities`: para exibir pousadas por cidade
		-  `block_owners_with_inn`: evita tentativa de criação de segunda pousada.
		- `set_room`: para definir a lista de quartos da pousada no método `show` **²**
- **rooms_controller.rb:**
	- métodos de recurso: `show`, `new`, `create`, `edit`, `update`
	- métodos privados: `set_room` e `room_params`, para definição de variáveis de quarto
  - método customizado: `set_room` agora chama `check_ownership`
- **seasonals_controller.rb:**
	- métodos de recurso: `show`, `new`, `create`, `edit`, `update` **³**
	- métodos privados: `set_seasonal`, `seasonal_params`, para definição de variáveis de período
	- método customizado: `room_seasonals`: busca lista de períodos no mesmo quarto

***Views e Navegação***

- **Devise**
	- */registrations/_owner.html.erb e */registrations/_customer.html.erb*:
	formulários de registro com envio de `user_type` pré-definido
- **Layouts**
	- *application.html.erb*: menu condicional (tipos de usuários e visitantes não logados)
- **Inns**
	-  *new*, *edit*, *show* e *cities*
	-  *_errors*: lista erros em ações relacionadas
	- *_form*: formulário de criação e edição
	- *_submenu*: comandos para administração dos quartos
- **Rooms**
	- *new*, *edit* e *show*
	- *_errors*: lista erros em ações relacionadas
	- *_form*: formulário de criação e edição
	- *_submenu*: comandos para administração dos quartos
- **Seasonals**
	- *new*
 	- *_index*: renderizado em 'rooms/show'
	- *_errors*: lista erros em ações relacionadas
	- *_form*: formulário de criação e edição
	- *_submenu*: comandos para administração dos quartos
	
***Routes***
- Rotas de seasonal subordinadas e rooms
- Redirecionamento direto para página de Pousadas por Cidade
- Especificação dos modelos registrations e sessions para o devise

***Gems no Dev***: devise, puma, sqlite3, i18n

***Acessos restritos***
- O acesso à páginas de edição está restrito nas views, checando a variável `@owner_view` do método `check_ownership`

***Testes de Sistema***
- Owner > Pousada > Altera
	- Owner altera os dados da pousada com sucesso
	- Owner altera os dados da pousada e falha por validação de cpnj
- Owner > Pousada > Cria
	- Owner cadastra pousada clicando em Cadastrar Pousada
	- Owner cadastra pousada logo após criar sua conta.
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
- Owner > Período > Cria
	- Owner cría novo Período clicando em Períodos Especiais
	- Owner cria novo Período e falha por sobreposição de data
	- Owner cria novo Período e falha por superação de data
	- Owner cria novo Período com sucesso
- Owner > Login
	- Owner clica no botão Entrar e vê a página de login
 	- Owner clica no botão Entrar e falha ao fazer login
	- Owner tenta criar uma nova conta mas email já está em uso como Customer
	- Owner cria uma nova conta mas email já está em uso como Owner
	- Owner cria uma nova conta mas falha na confirmação de senha
 	- Owner clica no botão Entrar e faz login com sucesso
  	- Owner clica no botão Entrar com sucesso e é levado para criar a pousada
- Visitante > Acesso
	- Visitante acessa o site e as pousadas antigas
	- Visitante acessa o site e vê as pousadas mais recentes

***Testes de Modelo*** em construção (previsão 13/11)

***Gems nos testes***: faker, rspec, capybara

-------------------------
> ***notas:***
> 
> ***¹*** Mas deve retornar à configuração em initializers se o problema for resolvido;
> ***²*** Pode depois ser eliminado com a criação de uma parcial no namespace rooms chamada pela view em inns;
> ***³*** Ainda falta criar *delete* e *destroy*.