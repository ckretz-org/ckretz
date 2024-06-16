require 'swagger_helper'

RSpec.describe SecretsController, type: :request do
  path '/secrets.json' do
    get('list secrets') do
      consumes 'application/json'
      produces 'application/json'
      response(200, 'successful') do
        let(:current_user) { create(:user) }
        let(:secrets) { create_list(:secret, 2, user: current_user) }
        let(:'Accept') { 'application/json' }

        before do
          allow_any_instance_of(SecretsController).to receive(:current_user).and_return(current_user)
        end
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
    # post('create secret') do
    #   response(200, 'successful') do
    #
    #     after do |example|
    #       example.metadata[:response][:content] = {
    #         'application/json' => {
    #           example: JSON.parse(response.body, symbolize_names: true)
    #         }
    #       }
    #     end
    #     run_test!
    #   end
    # end
  end
  # path '/secrets/{id}' do
  #   # You'll want to customize the parameter types...
  #   parameter name: 'id', in: :path, type: :string, description: 'id'
  #
  #   get('show secret') do
  #     response(200, 'successful') do
  #       let(:current_user) { build(:user) }
  #       let(:secret_1) { build(:secret, user: current_user) }
  #       let(:current_user_secrets) { class_double(Secret) }
  #       let(:id) { secret_1.id }
  #
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  #
  #   put('update secret') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }
  #
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  #
  #   delete('delete secret') do
  #     response(200, 'successful') do
  #       let(:id) { '123' }
  #
  #       after do |example|
  #         example.metadata[:response][:content] = {
  #           'application/json' => {
  #             example: JSON.parse(response.body, symbolize_names: true)
  #           }
  #         }
  #       end
  #       run_test!
  #     end
  #   end
  # end
  #
end
