namespace :dev do
  desc "Popula o ambiente de desenvolvimento com dados Fake"
  task setup: :environment do
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
    puts "Processo finalizado com sucesso."
  end

end
