class Contact < ApplicationRecord
	belongs_to :kind

	def as_json(options={})
		super(
			# incluir atributos especificos
			include: { kind: { only: :description } },
			methods: [:kind_description]
			# incluir todos os atribuitos de kind
			# include: :kind
		)
	end

	def kind_description
		self.kind.description
	end
end
