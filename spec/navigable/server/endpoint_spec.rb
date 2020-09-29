RSpec.describe Navigable::Server::Endpoint do
  let(:endpoint_class) { Class.new { extend Navigable::Server::Endpoint } }

  describe '.responds_to' do
    subject(:responds_to) { endpoint_class.responds_to(verb, path) }

    let(:verb) { :get }
    let(:path) { '/' }

    before do
      allow(Navigable::Server).to receive(:add_endpoint)
      responds_to
    end

    it 'registers endpoint with server' do
      expect(Navigable::Server)
        .to have_received(:add_endpoint)
        .with(
          verb: verb,
          path: path,
          endpoint_class: endpoint_class
        )
    end
  end

  describe '.executes' do
    subject(:executes) { endpoint_class.executes(:swab_the_decks) }

    let(:endpoint_class) { Class.new { extend Navigable::Server::Endpoint } }

    before { executes }

    it 'sets the command key on the class' do
      expect(endpoint_class.instance_variable_get(:@command_key)).to eq(:swab_the_decks)
    end
  end

  describe '#inject' do
    let(:endpoint) { endpoint_class.new }

    context 'when request is NOT passed' do
      subject(:inject) { endpoint.inject }

      before { inject }

      it 'request defaults to a new Request object' do
        expect(endpoint.request).to be_a_kind_of(Navigable::Server::Request)
      end
    end

    context 'when request is passed' do
      subject(:inject) { endpoint.inject(request: request) }

      let(:request) { instance_double('request') }

      before { inject }

      it 'sets the request' do
        expect(endpoint.request).to eq(request)
      end
    end
  end

  describe '#execute' do
    subject(:execute) { endpoint.execute }

    let(:endpoint_class) do
      Class.new { extend Navigable::Server::Endpoint; executes :swab_the_decks }
    end

    let(:endpoint) { endpoint_class.new }

    let(:command_key) { :swab_the_decks }
    let(:request) { instance_double(Navigable::Server::Request, headers: headers, params: params) }
    let(:headers) { { preferred_media_type: 'application/json' } }
    let(:params) { 'params' }
    let(:result) { 'result' }

    before do
      allow(Navigable::Dispatcher).to receive(:dispatch).and_return(result)
      endpoint.inject(request: request)
    end

    it 'dispatches the command key' do
      execute

      expect(Navigable::Dispatcher)
        .to have_received(:dispatch)
        .with(
          command_key,
          params: request.params,
          resolver: a_kind_of(Navigable::NullResolver)
        )
    end

    it 'returns the result of dispatching the command' do
      expect(execute).to eq(result)
    end
  end
end