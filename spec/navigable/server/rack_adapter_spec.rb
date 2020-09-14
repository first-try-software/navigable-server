RSpec.describe Navigable::Server::RackAdapter do
  subject(:adapter) { described_class.new(endpoint_class: endpoint_class) }

  let(:endpoint_class) { class_double('endpoint') }

  describe '#call' do
    subject(:call) { adapter.call(env) }

    let(:env) { instance_double('env') }
    let(:request) { instance_double(Navigable::Server::Request) }
    let(:response) { instance_double(Navigable::Server::Response, to_rack_response: rack_response) }
    let(:endpoint) { instance_double('endpoint', execute: execution_result) }
    let(:execution_result) { { status: 200, json: {} } }
    let(:rack_response) { ['status', 'headers', ['body']] }

    before do
      allow(Navigable::Server::Request).to receive(:new).and_return(request)
      allow(Navigable::Server::Response).to receive(:new).and_return(response)
      allow(endpoint_class).to receive(:new).and_return(endpoint)

      call
    end

    it 'wraps the env in a Request object' do
      expect(Navigable::Server::Request).to have_received(:new).with(env)
    end

    it 'instantiates an endpoint object with the request' do
      expect(endpoint_class).to have_received(:new).with(request: request)
    end

    it 'executes the endpoint' do
      expect(endpoint).to have_received(:execute)
    end

    it 'wraps the execution result in a Response object' do
      expect(Navigable::Server::Response).to have_received(:new).with(execution_result)
    end

    it 'returns a rack response' do
      expect(call).to eq(rack_response)
    end
  end
end
