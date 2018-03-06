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

  describe '.variables' do
    before do
      stub_env_values({ 'GITLAB_USERNAME' => 'root',
                        'GITLAB_QA_ACCESS_TOKEN' => nil,
                        'EE_LICENSE' => nil })
      described_class.user_username = nil
      described_class.user_password = nil
      described_class.user_type = nil
      described_class.gitlab_url = nil
      described_class.ee_license = nil
    end

    it 'returns only these delegated variables that are set' do
      expect(described_class.variables).to eq({ 'GITLAB_USERNAME' => '$GITLAB_USERNAME' })
    end

    it 'prefers environment variables to defined values' do
      described_class.user_username = 'tanuki'

      expect(described_class.variables).to eq({ 'GITLAB_USERNAME' => '$GITLAB_USERNAME' })
    end

    it 'returns values that have been overriden' do
      described_class.user_password = 'tanuki'
      described_class.user_type = 'ldap'
      described_class.gitlab_url = 'http://localhost:9999'

      expect(described_class.variables).to eq({ 'GITLAB_USERNAME' => '$GITLAB_USERNAME',
                                                'GITLAB_PASSWORD' => 'tanuki',
                                                'GITLAB_USER_TYPE' => 'ldap',
                                                'GITLAB_URL' => 'http://localhost:9999' })
    end
  end

  def stub_env(name, value)
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with(name).and_return(value)
  end

  def stub_env_values(pairs)
    allow(ENV).to receive(:[]).and_call_original

    pairs.each do |key, value|
      allow(ENV).to receive(:[]).with(key).and_return(value)
    end
  end
end
