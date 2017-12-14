describe Gitlab::QA::Runtime::Env do
  describe '.screenshots_dir' do
    context 'when there is an env variable set' do
      before do
        stub_env('QA_SCREENSHOTS_DIR', '/tmp')
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.screenshots_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
      before do
        stub_env('QA_SCREENSHOTS_DIR', nil)
      end

      it 'returns a default screenshots directory' do
        expect(described_class.screenshots_dir)
          .to eq '/tmp/gitlab-qa/screenshots'
      end
    end
  end

  describe '.logs_dir' do
    context 'when there is an env variable set' do
      before do
        stub_env('QA_LOGS_DIR', '/tmp')
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.logs_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
      before do
        stub_env('QA_LOGS_DIR', nil)
      end

      it 'returns a default screenshots directory' do
        expect(described_class.logs_dir)
          .to eq '/tmp/gitlab-qa/logs'
      end
    end
  end

  describe '.delegated' do
    before do
      stub_env('GITLAB_USERNAME', 'root')
    end

    it 'returns a list of envs delegated to tests component' do
      expect(described_class.delegated).not_to be_empty
    end

    it 'returns only these delegated variables that are set' do
      expect(described_class.delegated).to include('GITLAB_USERNAME')
      expect(described_class.delegated).not_to include('GITLAB_PASSWORD')
    end
  end

  def stub_env(name, value)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with(name).and_return(value)
  end
end
