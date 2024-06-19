class AccessTokensController < ApplicationController
  include CurrentUser
  before_action :set_access_token, only: %i[ show destroy ]

  # GET /access_tokens or /access_tokens.json
  def index
    @access_tokens = current_user.access_tokens
  end

  # GET /access_tokens/1 or /access_tokens/1.json
  def show
  end

  # GET /access_tokens/new
  def new
    @access_token = current_user.access_tokens.new
    respond_to do |format|
      format.turbo_stream { render :new }
    end
  end

  # POST /access_tokens or /access_tokens.json
  def create
    @access_token = current_user.access_tokens.new(access_token_params)

    respond_to do |format|
      if @access_token.save
        format.html { redirect_to access_tokens_path, notice: "Access token was successfully created, copy this token: #{@access_token.token}" }
        format.json { render :show, status: :created, location: @access_token }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @access_token.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /access_tokens/1 or /access_tokens/1.json
  def destroy
    @access_token.destroy!

    respond_to do |format|
      format.html { redirect_to access_tokens_url, notice: "Access token was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_access_token
      @access_token = current_user.access_tokens.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def access_token_params
      params.require(:access_token).permit(:name)
    end
end
