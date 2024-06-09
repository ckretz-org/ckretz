class SecretValuesController < ApplicationController
  before_action :set_secret_value, only: %i[ destroy ]
  include CurrentUser

  # GET /secret_values/new
  def new
    respond_to do |format|
      format.html {
        @secret_value = SecretValue.new
      }
      format.turbo_stream {
        render turbo_stream: turbo_stream.append("secret_values", partial: "secret_values/secret_value", locals: { secret_value: SecretValue.new })
      }
    end
  end

  # DELETE /secret_values/1 or /secret_values/1.json
  def destroy
    @secret_value.destroy!

    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.remove(@secret_value)
      }
      # format.html { redirect_to secret_values_url, notice: "Secret value was successfully destroyed." }
      # format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_secret_value
    @secret_value = SecretValue.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def secret_value_params
    params.fetch(:secret_value, {})
  end
end
