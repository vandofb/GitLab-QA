describe Gitlab::QA::Docker::Specs do
  let(:docker) { spy('docker command') }

  before do
    stub_const('Gitlab::QA::Docker::Command', docker)
  end

  describe '#test' do
    context 'when docker-in-docker is available' do
      before do
        allow(Gitlab::QA::Runtime::Env)
          .to receive(:dind?).and_return(true)
      end

      it 'does not bind-mount a docker socket' do
        described_class.perform do |specs|
          specs.test(gitlab: spy('gitlab'))
        end

        expect(docker).not_to have_received(:volume)
          .with('/var/run/docker.sock', '/var/run/docker.sock')
      end

      it 'delegates DOCKER_HOST to the container' do
        described_class.perform do |specs|
          specs.test(gitlab: spy('gitlab'))
        end

        expect(docker).to have_received(:env)
          .with('DOCKER_HOST', '$DOCKER_HOST')
      end
    end

    context 'when docker-in-docker is not available' do
      before do
        allow(Gitlab::QA::Runtime::Env)
          .to receive(:dind?).and_return(false)
      end

      it 'bind-mounts a docker socket' do
        described_class.perform do |specs|
          specs.test(gitlab: spy('gitlab'))
        end

        expect(docker).to have_received(:volume)
          .with('/var/run/docker.sock', '/var/run/docker.sock')
      end

      it 'does not delegate DOCKER_HOST to the container' do
        described_class.perform do |specs|
          specs.test(gitlab: spy('gitlab'))
        end

        expect(docker).not_to have_received(:env)
          .with('DOCKER_HOST', '$DOCKER_HOST')
      end
    end
  end
end
