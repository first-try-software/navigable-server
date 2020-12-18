RSpec.describe 'Server' do
  let(:request) { Rack::MockRequest.new(app) }
  let(:app) { Navigable::Server.rack_app }
  let(:uri) { '/ahoy' }
  let(:response) { request.get(uri, options) }
  let(:options) { { 'HTTP_ACCEPT' => 'application/json' } }

  after { Manufacturable.reset! }

  context 'when the endpoint overrides authenticated to return false' do
    let!(:endpoint_class) do
      Class.new do
        extend Navigable::Server::Endpoint

        responds_to :get, '/ahoy'

        executes :ahoy_matey

        def authenticated?
          false
        end
      end
    end

    it 'returns an unauthenticated response' do
      expect(response.status).to eq(401)
      expect(response.body).to eq('Unauthorized')
    end
  end

  context 'when the endpoint overrides authorized to return false' do
    let!(:endpoint_class) do
      Class.new do
        extend Navigable::Server::Endpoint

        responds_to :get, '/ahoy'

        executes :ahoy_matey

        def authorized?
          false
        end
      end
    end

    it 'returns an unauthorized response' do
      expect(response.status).to eq(403)
      expect(response.body).to eq('Forbidden')
    end
  end

  context 'when the endpoint does NOT declare a command to execute' do
    context 'and the endpoint does NOT define an execute method' do
      let!(:endpoint_class) do
        Class.new do
          extend Navigable::Server::Endpoint

          responds_to :get, '/ahoy'
        end
      end

      it 'raises an error' do
        expect { response }.to raise_error(NotImplementedError)
      end
    end

    context 'and the endpoint defines an execute method' do
      let!(:endpoint_class) do
        Class.new do
          extend Navigable::Server::Endpoint

          responds_to :get, '/ahoy'

          def execute
            { text: 'Ahoy!' }
          end
        end
      end

      it 'executes the provided execute method' do
        expect(response.body).to eq('Ahoy!')
      end
    end
  end

  context 'when the endpoint declares a command to execute' do
    let!(:endpoint_class) do
      Class.new do
        extend Navigable::Command

        corresponds_to :recruit_swabbie

        def execute
          successfully recruited_swabbie
        end

        def recruited_swabbie
          { rank: 'swabbie', id: 123 }
        end
      end

      Class.new do
        extend Navigable::Resolver

        resolves 'application/json'

        def resolve
          @response
        end

        def on_success(data)
          @response = { json: data }
        end
      end

      Class.new do
        extend Navigable::Server::Endpoint

        responds_to :get, '/ahoy'

        executes :recruit_swabbie
      end
    end

    it 'responds with the result of executing the command' do
      expect(JSON.parse(response.body)).to eq({ 'rank' => 'swabbie', 'id' => 123 })
    end
  end
end