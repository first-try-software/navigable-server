RSpec.describe Navigable::Server do
  it "has a version number" do
    expect(Navigable::Server::VERSION).not_to be nil
  end

  describe '#rack_app' do
    subject(:rack_app) { Navigable::Server.rack_app }

    it 'returns a Rack::Builder' do
      expect(rack_app).to be_a_kind_of(Rack::Builder)
    end

    it 'returns the same object every time' do
      expect(rack_app).to be(Navigable::Server.rack_app)
    end
  end

  describe '#add_endpoint' do
    subject(:add_endpoint) { Navigable::Server.add_endpoint(**params) }

    let(:params) { { verb: :verb, path: :path, endpoint_class: :endpoint_class } }

    before do
      allow(Navigable::Server.router).to receive(:add_endpoint)
      add_endpoint
    end

    it 'delegates to the router' do
      expect(Navigable::Server.router).to have_received(:add_endpoint).with(params)
    end
  end

  describe '#router' do
    subject(:router) { Navigable::Server.router }

    it 'returns a Navigable::Server::router' do
      expect(router).to be_a_kind_of(Navigable::Server::Router)
    end

    it 'returns the same object every time' do
      expect(router).to be(Navigable::Server.router)
    end
  end
end
