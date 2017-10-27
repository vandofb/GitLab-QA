describe Gitlab::QA::Runtime::Env do
  describe '.screenshots_dir' do
    context 'when there is an env variable set' do
      before { stub_env('QA_SCREENSHOTS_DIR', '/tmp') }

      it 'returns directory defined in environment variable' do
        expect(described_class.screenshots_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
      before { stub_env('QA_SCREENSHOTS_DIR', nil) }

      it 'returns a default screenshots directory' do
        expect(described_class.screenshots_dir)
          .to eq '/tmp/gitlab-qa-screenshots'
      end
    end
  end

  describe '.delegated' do
    it 'returns a list of envs delegated to tests component' do
      expect(described_class.delegated).not_to be_empty
    end

    it 'appends docker host if docker-in-docker is available' do
      stub_env('DOCKER_HOST', '192.168.1.101')

      expect(described_class.delegated).to include 'DOCKER_HOST'
    end
  end

  describe '.dind?' do
    it 'returns true when docker-in-docker is available' do
      stub_env('DOCKER_HOST', '192.168.1.101')

      expect(described_class.dind?).to eq true
    end

    it 'returns false when docker-in-docker is not available' do
      stub_env('DOCKER_HOST', nil)

      expect(described_class.dind?).to eq false
    end
  end

  def stub_env(name, value)
    allow(ENV).to receive(:[]).with(name).and_return(value)
  end
end
