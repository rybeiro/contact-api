# Infomarções úteis para projetos Rails
## SEEDs
_Seeds_ para popular as tabelas.
```ruby
# exibir tasks disponíveis
rails -T

# Criar seeds | dev (task) setup (nome da task)
rails g task dev setup

# A nova seed está localizado em: lib/tasks/dev.rb
# executar a task
rails dev:setup
```

## Render JSON
Responsável pelo retorno e faz a transformação do objeto para json

### Active support JSON
_JSON.decode()_ parseia um json em Hash.

_JSON.encode()_ parseria um hash em JSON. também disponível o atalho to_json.

### Active Model Serializers JSON
_as_json_ parsei um objeto em hash

```ruby
# exemplo
contact = Contact.first
contact.as_json
```

_from_json_ ...

#### Root
Para exibir o elemento raiz de cada objeto json.
```ruby
# acresentar no render do json => root: true 
render json: @contacts, root: true
```

### Definindo os atributos para retorno no JSON
É possível incluir novos atributos ou métodos no retorno do JSON. Isso é para conhecimento, mas preferencialmente utilize o _as_json_ no _Model_
```ruby
# retornar somente o email
render json: @contacts, only: [:email]

# retornar exceto o id
render json: @contacts, except: [:id]

# Incluir atributos no retorno no all()
render json: @contacts.map{|contact| contact.attributes.merge({ author: "Meu nome aqui"})}

# Incluir atribuitos no retorno do show()
render json: @contact.attributes.merge({author: "Meu nome aqui"})

## INCLUÍNDO MÉTODOS NO RETORNO
# methods: :author ( o método author deve ser implementado no Model )
render json: @contacts, methods: :author
```

## Render JSON com associações
Para incluir as associação no retorno, deve-se incluir no _as_json_ do Model o _include_
```ruby
# incluindo a associação
def as_json(options={})
	super( include: :kind )
end

# incluindo um atributo especifico da associação
def as_json(options={})
	super( include: {kind: {only: :description}} )
end

# incluir apenas a descrição como atributo
def kind_description
	self.kind.description
end

def as_json(options={})
	super( methods: kind_description)
end
```

## Post nas associações
Tornando a associção opcional no create
```ruby
#tornando a associação opcional
belongs_to :kind, optional: true
```

Para salvar as associações deve-se permitir a associação no controller.
```ruby
def contact_params
  params.require(:contact).permit(:name, :email, :birthdate, :kind_id)
end
```

# I18n - Internacionalização
Configurando o idioma do sistema como padrão em Português Brasil.
```ruby
# Incluir a gem rails-i18n e depois executar o bundle install
# criar o arquivo config/initializer/locale.rb

I18n.default_locale = 'pt-BR'

# as traduções devem ficar no arquivo config/locales/pt-BR.yml
# exemplo
'pt-BR':
  hello: "Olá mundo!"

## Utilizando o i18n
I18n.translate('hello') # ou I18n.t('hello')

# Identificando o idioma do sistema
I18n.default_locale

# alterando o idioma
I18n.default_locale = :en
I18n.default_locale = :'pt-BR'
```

## I18n para Datas
```ruby
# parsear para o idioma padrão
I18n.l(Date.today)

# traduzir atributos os as_json no Model
# Model Contact
# sobrescrita do as_json
def as_json(options={})
	h = super(options)
	h[:birthdate] = I18n.l(self.birthdate)
end

```

# has_many
Estudar _Nested Attributes_ na api.rubyonrails.org

### criar contatos e telefones aninhados

```ruby
# Possibilita a inclusão dos Phone junto com um Contact
# Model Contact
has_many :phones
accepts_nested_attributes_for :phones

# estrutura de dados para cadastrar os telefones
# atributo mágico ( nome_associacao_attributes )
# exemplo: phones_attributes[{}, {}] 
params = { 
	"contact": {
		"name": "Teste",
		"email": "teste@test.com",
		"birthdate": "2012-12-12",
		"kind_id": 2,
		"phones_attributes": [
			{ "numer": "999999999"},
			{ "numer": "888888888"},
			{ "numer": "777777777"}
		]
	}
}

# Importante: Para associações has_many, ou seja, a tabela que recebe a chave estrangeira, não gerar com scaffold. segue exemplo:
rails g model Phone number:string

# também permitir o phones_attributes no ContactController no método contact_params

def contact_params
	params.require(:contact).permit(:name, :email, :birthdate, :kind_id, phones_attributes: [:id, :number])
end
```

### atualizar contatos com os telefones aninhados
Para atualizar um determinado contato com o telefone, deve-se enviar no post o id do phone
```ruby
# estrutura necessária
# PUT => localhost:3000/contacts/1
params = {
	"contact": {
		"name": "João de Tals"
		"phones_attributes": {
			"id": 1,
			"number": "999888777"
		}
	}
}

```

### Apagar um contato com os telefones aninhados
Incluir _allow_destroy: true_ no Model além utilizar o método update informando o id do phone e o parâmetro \_destroy
```ruby
# Model Contact
has_many :phones
accepts_nested_attributes_for :phones, allow_destroy: true


# Controller Contact
def contact_params
	params.require(:contact).permit(:name, :email, :birthdate, :kind_id, phones_attributes: [:id, :number, _destroy])
end

# estrutura necessária
# PUT => localhost:3000/contacts/1
params = {
	"contact": {
		"name": "João de Tals"
		"phones_attributes": {
			"id": 1,
			"_destroy": 1
		}
	}
}
```

# has_one
Gerar o model address
```ruby
# Model Address
rails g model Address street:string city:string contact:references

# Já devemos ativar o Nested Attributes no Model Contact e incluir o relacionamento
# Model Contact
has_one :address
accepts_nested_attributes_for :address
```

### Render json do CRUD para o has_one
#### Read
Incluir no render json
```ruby
render json: @contact, include: [:address]
```
#### Create 
Permitir no controller e no Model permitir na associação optional para possibilitar a inserção.
```ruby
# Contact Controller
def contact_params
	params.require(:contact).permit(
		:name,
		:email,
		:birthdate,
		:kind_id,
		phones_attributes: [
			:id, :number, :_destroy
		],
		address_attributes: [
			:id, :street, :city
		]
	)
end

# Address Model
belongs_to :contact, optional: true
```

# CORS
Descomentar a gem 'rack-cors' e executar o bundle

Site para fazer teste de cors: resttesttest.com

Acessar o arquivo config/initializer/cors.rb e descomentar.

# AMS - Active Model Serializers



