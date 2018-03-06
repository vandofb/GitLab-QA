describe Gitlab::QA::Docker::Engine do
  let(:docker) { spy('docker') }

  before do
    stub_const('Gitlab::QA::Docker::Shellout', docker)
  end

  describe '#pull' do
    it 'pulls docker image' do
      subject.pull('gitlab/gitlab-ce', 'nightly')

      expect(docker).to have_received(:new)
        .with(eq('docker pull gitlab/gitlab-ce:nightly'))
    end
  end

  describe '#run' do
    it 'runs docker container' do
      subject.run('gitlab/gitlab-ce', 'nightly', 'cmd')

      expect(docker).to have_received(:new)
        .with(eq('docker run gitlab/gitlab-ce:nightly cmd'))
    end
  end

  describe '#stop' do
    it 'stops docker container' do
      subject.stop('some_container')

      expect(docker).to have_received(:new)
        .with(eq('docker stop some_container'))
    end
  end

  describe '#port' do
    it 'returns exposed TCP port' do
      subject.port('some_container', 80)

      expect(docker).to have_received(:new)
        .with(eq('docker port some_container 80/tcp'))
    end
  end
end
