describe Gitlab::QA::Runtime::Env do
  around do |example|
    # Reset any already defined env variables (e.g. on CI)
    ClimateControl.modify Hash[described_class::ENV_VARIABLES.keys.zip([nil])] do
      example.run
    end
  end

  describe '.screenshots_dir' do
    context 'when there is an env variable set' do
      around do |example|
        ClimateControl.modify(QA_SCREENSHOTS_DIR: '/tmp') { example.run }
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.screenshots_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
      around do |example|
        ClimateControl.modify(QA_SCREENSHOTS_DIR: nil) { example.run }
      end

      it 'returns a default screenshots directory' do
        expect(described_class.screenshots_dir)
          .to eq '/tmp/gitlab-qa/screenshots'
      end
    end
  end

  describe '.logs_dir' do
    context 'when there is an env variable set' do
      around do |example|
        ClimateControl.modify(QA_LOGS_DIR: '/tmp') { example.run }
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.logs_dir).to eq '/tmp'
      end
    end

    context 'when there is no env variable set' do
      around do |example|
        ClimateControl.modify(QA_LOGS_DIR: nil) { example.run }
      end

      it 'returns a default screenshots directory' do
        expect(described_class.logs_dir)
          .to eq '/tmp/gitlab-qa/logs'
      end
    end
  end

  describe '.variables' do
    around do |example|
      ClimateControl.modify(
        GITLAB_USERNAME: 'root',
        GITLAB_QA_ACCESS_TOKEN: nil,
        EE_LICENSE: nil) { example.run }
    end

    before do
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
end
