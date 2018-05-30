describe Gitlab::QA::Framework::Runtime::Env do
  include Support::StubENV

  describe '.chrome_headless?' do
    context 'when there is an env variable set' do
      it 'returns false when falsey values specified' do
        stub_env('CHROME_HEADLESS', 'false')
        expect(described_class).not_to be_chrome_headless

        stub_env('CHROME_HEADLESS', 'no')
        expect(described_class).not_to be_chrome_headless

        stub_env('CHROME_HEADLESS', '0')
        expect(described_class).not_to be_chrome_headless
      end

      it 'returns true when anything else specified' do
        stub_env('CHROME_HEADLESS', 'true')
        expect(described_class).to be_chrome_headless

        stub_env('CHROME_HEADLESS', '1')
        expect(described_class).to be_chrome_headless

        stub_env('CHROME_HEADLESS', 'anything')
        expect(described_class).to be_chrome_headless
      end
    end

    context 'when there is no env variable set' do
      it 'returns the default, true' do
        stub_env('CHROME_HEADLESS', nil)
        expect(described_class).to be_chrome_headless
      end
    end
  end

  describe '.running_in_ci?' do
    context 'when there is an env variable set' do
      it 'returns true if CI' do
        stub_env('CI', 'anything')
        expect(described_class).to be_running_in_ci
      end

      it 'returns true if CI_SERVER' do
        stub_env('CI_SERVER', 'anything')
        expect(described_class).to be_running_in_ci
      end
    end

    context 'when there is no env variable set' do
      it 'returns true' do
        stub_env('CI', nil)
        stub_env('CI_SERVER', nil)
        expect(described_class).not_to be_running_in_ci
      end
    end
  end
end
