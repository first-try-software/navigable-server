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

  describe '#execute' do
    subject(:execute) { endpoint_class.new.execute }

    it 'yells at you to implement the method in your endpoint class' do
      expect { execute }.to raise_error(NotImplementedError)
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
end