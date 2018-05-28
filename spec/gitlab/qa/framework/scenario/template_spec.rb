describe Gitlab::QA::Framework::Scenario::Template do
  subject do
    Class.new.include(described_class)
  end

  it { expect(subject).to include(Gitlab::QA::Framework::Scenario::Actable) }
  it { expect(subject).to include(Gitlab::QA::Framework::Scenario::Bootable) }

  describe '.skip_pull?' do
    it 'defaults to false' do
      subject.launch!

      expect(Gitlab::QA::Framework::Runtime::Scenario.skip_pull?).to be(false)
    end

    it 'can be set to true' do
      subject.launch!(['--skip-pull'])

      expect(Gitlab::QA::Framework::Runtime::Scenario.skip_pull?).to be(true)
    end
  end
end
