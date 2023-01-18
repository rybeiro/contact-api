namespace :dev do
  desc "Popula o ambiente de desenvolvimento com dados Fake"
  task setup: :environment do
    
    # Executa comando de terminal
    # %x(rails db:drop db:create db:migrate dev:setup)

    Faker::Config.locale = 'pt-BR'

    puts "Cadastrando tipos de contatos...."
    kinds = %w(Amigo Familiar Comercial Outros)

    kinds.each do |kind|
      Kind.create!(description: kind)
    end

    puts "Cadastrando contatos...."
    100.times do |i|
      Contact.create!(
        name: Faker::Name.name,
        email: Faker::Internet.email,
        birthdate: Faker::Date.between(from: 65.years.ago, to: 18.years.ago),
        kind: Kind.all.sample
      )
    end

    puts "Cadastrando os telefone ...."
    Contact.all.each do |contact|
      Random.rand(5).times do |i|
        Phone.create!(
          number: Faker::PhoneNumber.cell_phone,
          contact: contact
        )
      end
    end

    puts "Cadastrando os endereços"
    Contact.all.each do |contact|
      Address.create!(
        street: Faker::Address.street_address,
        city: Faker::Address.city,
        contact: contact
      )
    end 
    puts "Processo finalizado com sucesso."
  end
end
