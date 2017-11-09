describe Gitlab::QA::Component::Specs do
  let(:docker) { spy('docker command') }

  before do
    stub_const('Gitlab::QA::Docker::Command', docker)
  end

  describe '#perform' do
    it 'bind-mounts a docker socket' do
      described_class.perform do |specs|
        specs.suite = spy('suite')
        specs.release = spy('release')
      end

      expect(docker).to have_received(:volume)
        .with('/var/run/docker.sock', '/var/run/docker.sock')
    end
  end
end
