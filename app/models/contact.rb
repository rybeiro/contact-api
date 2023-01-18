class Contact < ApplicationRecord
	belongs_to :kind
	has_many :phones
	has_one :address
	accepts_nested_attributes_for :phones, allow_destroy: true
	accepts_nested_attributes_for :address

	# def as_json(options={})
	# 	super(
	# 		# incluir atributos especificos
	# 		include: { kind: { only: :description } },
	# 		methods: [:kind_description]
	# 		# incluir todos os atribuitos de kind
	# 		# include: :kind
	# 	)
	# end

	# def kind_description
	# 	self.kind.description
	# end
end
