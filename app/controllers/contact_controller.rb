class ContactController < InnerPageController
  #before_action :initialize_contact_page
  def index
    initialize_contact_page
    init_metadata

    @message = Message.new
  end

  def initialize_contact_page
    @contact_page = true
    @breadcrumbs.push({title: I18n.t("breadcrumbs.contact"), url: false, current: true})
    I18n.available_locales.select{|locale| locale.to_sym != I18n.locale.to_sym }.each do |locale|
      @locale_links[locale.to_sym] = ContactPage.first.to_param(locales_priority: [another_locale, I18n.locale])
    end
    @map_markers = [[49.843031, 24.041205, "test-header", "test-description"] ]
  end

  def post_message
    successful = false
    initialize_contact_page
    init_metadata

    @message = Message.new(params[:message])
    if @message.valid?
      successful = true
      MessageMailer.create_message(@message).deliver_now
    end
    @status =  successful ? :successful : :error
    flash[:notice] = I18n.t("simple_form.notices.message.#{@status}")

    respond_to do |format|
      format.html { render template: "contact/index" }
      format.json { render inline: {successful: true}.to_json }
    end

    #render inline: @message.errors.values.inspect if !successful

  end

  def init_metadata
    @page_metadata = ContactPage.first.try(&:page_metadata)
  end
end
