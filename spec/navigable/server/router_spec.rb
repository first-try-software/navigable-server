RSpec.describe Navigable::Server::Router do
  subject(:router) { described_class.new }

  let(:hanami_router) { instance_double(Hanami::Router, call: true) }

  before do
    allow(Hanami::Router).to receive(:new).and_return(hanami_router)
  end

  describe '#call' do
    subject(:call) { router.call(env) }

    let(:env) { 'env' }

    before { call }

    it 'delegates to the hanami router' do
      expect(hanami_router).to have_received(:call).with(env)
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
      allow(Navigable::Server::Routes).to receive(:new).and_return(routes)
      allow(hanami_router).to receive(verb)
      add_endpoint
    end

    it 'wraps the endpoint in a rack adapter' do
      expect(Navigable::Server::RackAdapter)
        .to have_received(:new)
        .with(endpoint_class: endpoint_class)
    end

    it 'adds the route to the hanami router' do
      expect(hanami_router).to have_received(verb).with(path, to: rack_adapter)
    end

    it 'adds a route to the routes' do
      expect(routes).to have_received(:add).with(verb, path, endpoint_class)
    end
  end

  describe '#routes' do
    subject(:routes) { router.routes }

    it 'returns a routes object' do
      expect(routes).to be_a_kind_of(Navigable::Server::Routes)
    end

    it 'returns the same object every time' do
      expect(routes).to eq(router.routes)
    end
  end
end