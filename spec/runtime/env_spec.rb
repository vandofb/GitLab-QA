describe Gitlab::QA::Runtime::Env do
  describe '.screenshots_dir' do
    context 'when there is an env variable set' do
      before do
        allow(ENV).to receive(:[])
          .with('QA_SCREENSHOTS_DIR')
          .and_return('/tmp')
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.screenshots_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
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
  end
end
