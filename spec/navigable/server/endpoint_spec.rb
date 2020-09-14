RSpec.describe Navigable::Server::Endpoint do
  describe '.responds_to' do
    subject(:responds_to) { described_class.responds_to(verb, path) }

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
          endpoint_class: described_class
        )
    end
  end

  describe '#execute' do
    subject(:execute) { described_class.new(request: request).execute }

    let(:request) { instance_double('request') }

    it 'yells at you to implement the method in your child class' do
      expect { execute }.to raise_error(NotImplementedError)
    end
  end
end