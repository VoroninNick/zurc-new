# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

include Faker
# create articles
model = Article

100.times do
  model_instance = model.new
  model_instance.release_date = Faker::Date.between(2.months.ago, Date.today)
  model_instance.published = true
  I18n.available_locales.each do |locale|
    I18n.with_locale locale do
      t = model_instance.translations.build(locale: locale)
      t.name = Lorem.sentence
      t.description = Lorem.sentences(2).join(' ')
      t.intro = rand(1) > 0 ? '' : Lorem.paragraph
      t.content = Lorem.paragraphs(3..5).map{|paragraph| "<p>#{paragraph}</p>"  }.join()
      t.author = Name.name
    end
  end
  model_instance.save
end
