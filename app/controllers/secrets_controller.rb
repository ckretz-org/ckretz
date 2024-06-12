class SecretsController < ApplicationController
  include CurrentUser
  include Pagy::Backend
  before_action :set_secret, only: %i[ show edit update destroy ]

  # GET /secrets or /secrets.json
  def index
    @secrets = current_user.secrets
    @secrets = @secrets.search(params[:query]) if params[:query].present?
    @pagy, @secrets = pagy(@secrets.reorder(sort_column => sort_direction), items: params.fetch(:count, 10))
  end

  def sort_column
    %w[name created_at].include?(params[:sort]) ? params[:sort] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  # GET /secrets/1 or /secrets/1.json
  def show
  end

  # GET /secrets/new
  def new
    @secret = current_user.secrets.new
    @secret.secret_values.build
    respond_to do |format|
      format.turbo_stream { render :new }
    end
  end

  # GET /secrets/1/edit
  def edit
  end

  # POST /secrets or /secrets.json
  def create
    @secret = current_user.secrets.new(secret_params)

    respond_to do |format|
      if @secret.save
        format.turbo_stream { render :create_success }
        format.html { redirect_to :secrets, notice: "Created successfully." }
        format.json { render :show, status: :created, location: @secret }
      else
        format.turbo_stream { render :create_failure }
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /secrets/1 or /secrets/1.json
  def update
    respond_to do |format|
      if @secret.update(secret_params)
        format.turbo_stream { render :create_success }
        format.html { redirect_to secret_url(@secret), notice: "Successfully updated." }
        format.json { render :show, status: :ok, location: @secret }
      else
        format.turbo_stream { render :create_failure }
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1 or /secrets/1.json
  def destroy
    @secret.destroy!

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to secrets_url, notice: "Secret was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
  def set_secret
    @secret = current_user.secrets.find(params[:id])
  end

  def secret_params
    params.require(:secret).permit(:name, secret_values_attributes: [ :id, :name, :value ])
  end
end
