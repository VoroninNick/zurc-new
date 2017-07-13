class PageController < ApplicationController
  def index
    @home_slides = HomeSlide.published
    @home_first_abouts = HomeFirstAbout.published
    @home_second_abouts = HomeSecondAbout.published
    @home_gallery_images = HomeGalleryImage.published
    @featured_articles = Article.published.news.featured

    I18n.available_locales.each do |locale|
      @locale_links[locale.to_sym] = "/#{locale}"
    end

    render layout: 'home'
    #output_map_coordinates
  end

  def about
  end

  def what_we_do
    @breadcrumbs = [
        { title: 'ЩО МИ РОБИМО' }
    ]
  end

  def custom_page
    render inline: params.inspect
  end


  def output_map_coordinates

    arr = [
        [50.206019,24.515452, "с. Бабичі", "Радехівський р-н."],
        [50.221019,24.545452, "с. Вузлове", "Радехівський р-н."],
        [50.034147,24.139682, "с. Зіболки", "Жовківський р-н."],
        [49.204957,23.036952, "с. Явора", "Турківський р-н."],
        [49.977222,23.556667, "с. Старичі", "Яворівський р-н."],
        [49.508056,23.249722, "с. Ралівка", "Самбірський р-н."],
        [50.459444,24.398333, "с. Тартаків", "Сокальський р-н."],
        [49.25573,23.846488, "м. Стрий"],
        [49.397801,24.693834, "с. Пуків", "Рогатинський р-н."],
        [49.389024,24.726263, "с. Чесники", "Рогатинський р-н."],
        [48.552751,25.046425, "с. Верхній ключів", "Коломийський р-н."],
        [49.245278,24.741944, "с. Жалибори", "Галицький р-н."],
        [48.712222,24.381111, "с. Раковець", "Богородчанський р-н."],
        [48.595556,25.438889, "с. Торговиця", "Городенківський р-н."],
        [49.388056,25.6175, "смт. Микулинці", "Теребовлянський р-н."],
        [47.260431,37.783818, "с. Павлопіль", "Новоазовський р-н."],
        [47.31655,37.946665, "с. Приморське", "Новоазовський р-н."],
        [47.316342,37.153555, "с. Новокраснівка", "Володарський р-н."],
        [48.661667,38.002222, "с. Парасковіївка", "Артемівський р-н."],
        [48.636667,36.960833, "с. Іверськe", "Олександрівський р-н."],
        [45.336389,35.0675, "с. Урожайне", "Совєтський р-н."],
        [45.374722,34.719722, "с. Іванівка", "Нижньогірський р-н."],
        [45.5775,33.345833, "с. Березівка", "Роздольненський р-н."],
        [45.238889,33.592778, "с. Охотніково", "Сакський р-н."],
        [45.37,33.952222, "с. Стаханівка", "Первомайський р-н."]
    ]

    render inline: arr.as_json
  end
end
