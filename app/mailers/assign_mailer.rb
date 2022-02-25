class AssignMailer < ApplicationMailer
  default from: 'skyekupai@gmail.com'

  def assign_mail(email, password)
    @email = email
    @password = password
    mail to: @email, subject: I18n.t('views.messages.complete_registration')
  end

  def transfer_owner_mail(email)
    @email = email
    mail to: @email, subject: "Owner transfer is successful"
  end

  def destroy_agenda_mail(email)
    @email = email
    mail to: @email, subject: "Agenda is destroyed"
  end
end