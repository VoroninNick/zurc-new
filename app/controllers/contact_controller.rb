class ContactController < InnerPageController
  def index
    initialize_contact_page

    @message = Message.new
  end

  def initialize_contact_page
    @breadcrumbs.push({title: "Контакти", url: false, current: true})

    @map_markers = [{lat: 49.843031, lng: 24.041205 }]
  end

  def post_message
    successful = false
    initialize_contact_page

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
end
