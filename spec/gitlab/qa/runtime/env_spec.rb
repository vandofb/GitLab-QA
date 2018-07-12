describe Gitlab::QA::Runtime::Env do
  around do |example|
    # Reset any already defined env variables (e.g. on CI)
    ClimateControl.modify Hash[described_class::ENV_VARIABLES.keys.zip([nil])] do
      example.run
    end
  end

  describe '.run_id' do
    around do |example|
      described_class.instance_variable_set(:@run_id, nil)
      example.run
      described_class.instance_variable_set(:@run_id, nil)
    end

    it 'returns a unique run id' do
      now = Time.now
      allow(Time).to receive(:now).and_return(now)
      allow(SecureRandom).to receive(:hex).and_return('abc123')

      expect(described_class.run_id).to eq "gitlab-qa-run-#{now.strftime('%Y-%m-%d-%H-%M-%S')}-abc123"
      expect(described_class.run_id).to eq "gitlab-qa-run-#{now.strftime('%Y-%m-%d-%H-%M-%S')}-abc123"
    end
  end

  describe '.host_artifacts_dir' do
    around do |example|
      described_class.instance_variable_set(:@host_artifacts_dir, nil)
      example.run
      described_class.instance_variable_set(:@host_artifacts_dir, nil)
    end

    context 'when there is an env variable set' do
      around do |example|
        ClimateControl.modify(QA_ARTIFACTS_DIR: '/tmp') { example.run }
      end

      it 'returns directory defined in environment variable' do
        expect(described_class.host_artifacts_dir).to eq "/tmp/#{described_class.run_id}"
      end
    end

    context 'when there is no env variable set' do
      around do |example|
        ClimateControl.modify(QA_ARTIFACTS_DIR: nil) { example.run }
      end

      it 'returns a default screenshots directory' do
        expect(described_class.host_artifacts_dir)
          .to eq "/tmp/gitlab-qa/#{described_class.run_id}"
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
