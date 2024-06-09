class SecretValuesController < ApplicationController
  before_action :set_secret_value, only: %i[]
  include CurrentUser

  # GET /secret_values/new
  def new
    respond_to do |format|
      # format.html {
      #   @secret_value = SecretValue.new
      # }
      format.turbo_stream {
        render turbo_stream: turbo_stream.append("secret_values", partial: "secret_values/secret_value", locals: { secret_value: SecretValue.new })
      }
    end
  end

  # DELETE /secret_values/1 or /secret_values/1.json
  def destroy
    @secret_value = current_user.secret_values.find(params[:id])
    @secret_value.destroy
  rescue ActiveRecord::RecordNotFound
    @secret_value = params[:id]
  ensure
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove(@secret_value)
      }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_secret_value
    @secret_value = current_user.secret_values.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def secret_value_params
    params.fetch(:secret_value, {})
  end
end
