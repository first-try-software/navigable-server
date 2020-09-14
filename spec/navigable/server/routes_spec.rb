RSpec.describe Navigable::Server::Routes do
  subject(:routes) { described_class.new(stdout) }

  let(:stdout) { instance_double('stdout', puts: true) }

  describe '#print' do
    subject(:print) { routes.print }

    context 'when there are NO routes' do
      before { print }

      it 'does NOT print anything' do
        expect(stdout).not_to have_received(:puts)
      end
    end

    context 'when there are routes' do
      let(:endpoint_class) { class_double('endpoint', to_s: 'Endpoint') }

      before do
        routes.add(:get, '/', endpoint_class)
        routes.add(:post, '/', endpoint_class)
        print
      end

      it 'prints the routes' do
        expect(stdout).to have_received(:puts).with('     GET / => Endpoint')
        expect(stdout).to have_received(:puts).with('    POST / => Endpoint')
      end
    end
  end
end