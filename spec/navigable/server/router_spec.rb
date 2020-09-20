RSpec.describe Navigable::Server::Router do
  subject(:router) { described_class.new }

  let(:navigable_router) { instance_double(Navigable::Router, call: true) }

  before do
    allow(Navigable::Router).to receive(:new).and_return(navigable_router)
  end

  describe '#call' do
    subject(:call) { router.call(env) }

    let(:env) { 'env' }

    before { call }

    it 'delegates to the navigable router' do
      expect(navigable_router).to have_received(:call).with(env)
    end
  end

  describe '#add_endpoint' do
    subject(:add_endpoint) { router.add_endpoint(**params) }

    let(:params) { { verb: verb, path: path, endpoint_class: endpoint_class } }
    let(:verb) { :get }
    let(:path) { '/' }
    let(:endpoint_class) { class_double('endpoint') }
    let(:rack_adapter) { instance_double(Navigable::Server::RackAdapter) }
    let(:routes) { instance_double(Navigable::Server::Routes, add: true) }

    before do
      allow(Navigable::Server::RackAdapter).to receive(:new).and_return(rack_adapter)
      allow(navigable_router).to receive(verb)
      add_endpoint
    end

    it 'wraps the endpoint in a rack adapter' do
      expect(Navigable::Server::RackAdapter)
        .to have_received(:new)
        .with(endpoint_class: endpoint_class)
    end

    it 'adds the route to the navigable router' do
      expect(navigable_router).to have_received(verb).with(path, to: rack_adapter)
    end
  end
end