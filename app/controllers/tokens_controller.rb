class TokensController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_token_operator, only: [:new, :create]
  before_action :authorize_counter_incharge, only: [:all_tokens, :live_tokens, :refresh_live_tokens, :update_status]

  def new
    @token = Token.new
  end

  def create
    @token = current_user.tokens.build(token_params)
    if @token.save
      redirect_to print_token_path(@token)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def print
    @token = Token.find(params[:id])

    pdf = Prawn::Document.new(page_size: 'A7', margin: [10, 20, 10, 20])
    pdf.font("Helvetica")

    pdf.text " ARTO Haridwar", align: :center, size: 14, style: :bold
    pdf.stroke_horizontal_rule
    pdf.move_down 5

    pdf.text "Token No: #{@token.token_number}", size: 13, style: :bold
    pdf.move_down 5
    pdf.text "Applicant: #{@token.applicant_name}", size: 12
    pdf.text "Vehicle: #{@token.vehicle_number}", size: 12
    pdf.text "Counter: #{@token.counter}", size: 12
    pdf.text "Status: #{@token.status}", size: 12
    pdf.move_down 5

    pdf.stroke_horizontal_rule
    pdf.move_down 3
    pdf.text "Date: #{Time.zone.now.strftime("%d-%m-%Y %H:%M")}", size: 10, align: :right
    pdf.text "ARTO Haridwar Office Token App", size: 8, align: :center, style: :italic

    send_data pdf.render, filename: "token_#{@token.token_number}.pdf", type: 'application/pdf', disposition: 'inline'
  end

  def all_tokens
    @tokens = Token.where(counter: current_user.assigned_counter)
                   .order(created_at: :desc)
                   .page(params[:page])
                   .per(10)
  end

  def live_tokens
    @tokens = Token.where(counter: current_user.assigned_counter)
                   .where("DATE(created_at) = ?", Time.zone.today)
                   .order(created_at: :desc)
  end

  def refresh_live_tokens
    @tokens = Token.where(counter: current_user.assigned_counter)
                   .where("DATE(created_at) = ?", Date.today)
                   .order(created_at: :desc)
    render partial: "tokens/dashboard_rows", locals: { tokens: @tokens }
  end

  def update_status
    @token = Token.find(params[:id])
    if @token.update(status: params[:status])
      redirect_to all_tokens_path, notice: "Status updated."
    else
      redirect_to all_tokens_path, alert: "Failed to update."
    end
  end

  def public_display
    @tokens = Token.where(status: "In Progress").order(created_at: :desc)
  end

  def refresh_in_progress
    @tokens = Token.where(status: "In Progress").order(created_at: :desc)
    render partial: "tokens/token_rows", locals: { tokens: @tokens }
  end

  private

  def token_params
    params.require(:token).permit(:applicant_name, :vehicle_number, :counter)
  end

  def authorize_token_operator
    unless current_user.token_operator?
      redirect_path = current_user.admin? ? admin_users_path : root_path
      redirect_to redirect_path, alert: "Access denied."
    end
  end

  def authorize_counter_incharge
    redirect_to root_path, alert: "Access denied." unless current_user.counter_incharge?
  end
end
