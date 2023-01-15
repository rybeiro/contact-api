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

```







