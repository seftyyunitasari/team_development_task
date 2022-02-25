class AgendasController < ApplicationController
  # before_action :set_agenda, only: %i[show edit update destroy]

  def index
    @agendas = Agenda.all
  end

  def new
    @team = Team.friendly.find(params[:team_id])
    @agenda = Agenda.new
  end

  def create
    @agenda = current_user.agendas.build(title: params[:title])
    @agenda.team = Team.friendly.find(params[:team_id])
    current_user.keep_team_id = @agenda.team.id
    if current_user.save && @agenda.save
      redirect_to dashboard_url, notice: I18n.t('views.messages.create_agenda') 
    else
      render :new
    end
  end

  def destroy
    @agenda = Agenda.find(params[:id])
    if current_user.id != @agenda.user_id
      if current_user.id == @agenda.team.owner_id
        @agenda.destroy
        @assigns = Assign.where(team_id: @agenda.team_id)
        @assigns.each do |assign|
          @member = User.find_by(user_id: assign.user_id)
          AssignMailer.destroy_agenda_mail(@member.email).deliver
        end
        redirect_to dashboard_url, notice: "Agenda was successfully deleted"
      else
        redirect_to dashboard_url, notice: "You cannot delete an agenda which does not belong to you"
      end
    else
      @agenda.destroy
      @assigns = Assign.where(team_id: @agenda.team_id)
        @assigns.each do |assign|
          @member = User.find_by(id: assign.user_id)
          AssignMailer.destroy_agenda_mail(@member.email).deliver
        end
      redirect_to dashboard_url, notice: "Agenda was successfully deleted"
    end
  end

  private

  def set_agenda
    @agenda = Agenda.find(params[:id])
  end

  def agenda_params
    params.fetch(:agenda, {}).permit %i[title description]
  end
end
