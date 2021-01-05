RSpec.describe Navigable::Server::EndpointCommand do
  let(:command_class) { Class.new { extend Navigable::Server::EndpointCommand } }
  let(:command_key) { :command_key }
  let(:verb) { :get }
  let(:path) { '/' }

  describe 'configuration' do
    before do
      allow(Navigable::Server).to receive(:add_endpoint)
      allow(command_class).to receive(:executes)
    end

    context 'when only responds_to is called' do
      before do
        command_class.responds_to(verb, path)
      end

      it 'does not register endpoint with server' do
        expect(Navigable::Server).not_to have_received(:add_endpoint)
      end
    end

    context 'when only corresponds_to is called' do
      before do
        command_class.corresponds_to(command_key)
      end

      it 'does not register endpoint with server' do
        expect(Navigable::Server).not_to have_received(:add_endpoint)
      end
    end

    context 'when responds_to is called first' do
      it 'registers endpoint with server' do
        command_class.responds_to(verb, path)
        command_class.corresponds_to(command_key)

        expect(Navigable::Server)
          .to have_received(:add_endpoint)
          .with(
            verb: verb,
            path: path,
            endpoint_class: a_class_extending(Navigable::Server::Endpoint)
          )
      end

      it 'registers command key' do
        allow(Navigable::Server).to receive(:add_endpoint) do |args|
          expect(args[:endpoint_class]).to receive(:executes).with(command_key)
        end

        command_class.responds_to(verb, path)
        command_class.corresponds_to(command_key)
      end
    end

    context 'when corresponds_to is called first' do
      it 'registers endpoint with server' do
        command_class.corresponds_to(command_key)
        command_class.responds_to(verb, path)

        expect(Navigable::Server)
          .to have_received(:add_endpoint)
          .with(
            verb: verb,
            path: path,
            endpoint_class: a_class_extending(Navigable::Server::Endpoint)
          )
      end

      it 'registers command key' do
        allow(Navigable::Server).to receive(:add_endpoint) do |args|
          expect(args[:endpoint_class]).to receive(:executes).with(command_key)
        end

        command_class.corresponds_to(command_key)
        command_class.responds_to(verb, path)
      end
    end
  end
end