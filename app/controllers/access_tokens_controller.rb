class AccessTokensController < ApplicationController
  before_action :set_access_token, only: %i[ show edit update destroy ]

  # GET /access_tokens or /access_tokens.json
  def index
    @access_tokens = AccessToken.all
  end

  # GET /access_tokens/1 or /access_tokens/1.json
  def show
  end

  # GET /access_tokens/new
  def new
    @access_token = AccessToken.new
  end

  # GET /access_tokens/1/edit
  def edit
  end

  # POST /access_tokens or /access_tokens.json
  def create
    @access_token = AccessToken.new(access_token_params)

    respond_to do |format|
      if @access_token.save
        format.html { redirect_to access_token_url(@access_token), notice: "Access token was successfully created." }
        format.json { render :show, status: :created, location: @access_token }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @access_token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /access_tokens/1 or /access_tokens/1.json
  def update
    respond_to do |format|
      if @access_token.update(access_token_params)
        format.html { redirect_to access_token_url(@access_token), notice: "Access token was successfully updated." }
        format.json { render :show, status: :ok, location: @access_token }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @access_token.errors, status: :unprocessable_entity }
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
      @access_token = AccessToken.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def access_token_params
      params.fetch(:access_token, {})
    end
end
