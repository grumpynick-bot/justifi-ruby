# frozen_string_literal: true

RSpec.describe Justifi::Payment do
  describe "create" do
    before do
      Justifi.setup(client_id: ENV["CLIENT_ID"],
                    client_secret: ENV["CLIENT_SECRET"],
                    environment: ENV["ENVIRONMENT"])
      Stubs::OAuth.success_get_token
    end

    let(:create_payment) { subject.send(:create, params: params) }

    context "with valid params" do
      before do
        Stubs::Payment.success_create(payment_params)
      end

      let(:payment_params) do
        {
          amount: 1000,
          currency: "usd",
          capture_strategy: "automatic",
          email: "example@opentrack.com",
          description: "Charging $10 on OpenTrack",
          payment_method: {
            card: {
              name: "JustiFi Tester",
              number: "4242424242424242",
              verification: "123",
              month: "3",
              year: "2040",
              address_postal_code: "55555"
            }
          }
        }
      end

      let(:params) { payment_params }

      it do
        response = create_payment
        expect(response).to be_a(Justifi::JustifiResponse)
        expect(response.http_status).to eq(201)
      end
    end

    context "with tokenized payment_method" do
      before do
        Stubs::PaymentMethod.success_create(card_params)
        Stubs::Payment.success_create(payment_params)
      end

      let(:card_params) {
        {
          payment_method: {
            card: {
              name: "JustiFi Tester",
              number: "4242424242424242",
              verification: "123",
              month: "3",
              year: "2040",
              address_postal_code: "55555"
            }
          }
        }
      }

      let(:tokenized_pm) { Justifi::PaymentMethod.create(params: card_params) }

      let(:payment_params) do
        {
          amount: 1000,
          currency: "usd",
          capture_strategy: "automatic",
          email: "example@opentrack.com",
          description: "Charging $10 on OpenTrack",
          payment_method: {
            token: tokenized_pm.data[:id]
          }
        }
      end

      let(:params) { payment_params }

      it do
        response = create_payment
        expect(response).to be_a(Justifi::JustifiResponse)
        expect(response.http_status).to eq(201)
      end
    end

    context "fails with invalid data" do
      before { Stubs::Payment.fail_create }
      let(:params) { {} }

      it do
        expect { create_payment }.to raise_error(Justifi::InvalidHttpResponseError)
      end
    end
  end
end