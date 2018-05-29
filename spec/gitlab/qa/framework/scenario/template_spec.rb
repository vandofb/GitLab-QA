describe Gitlab::QA::Framework::Scenario::Template do
  subject do
    Class.new.include(described_class)
  end

  it { expect(subject).to include(Gitlab::QA::Framework::Scenario::Actable) }
  it { expect(subject).to include(Gitlab::QA::Framework::Scenario::Bootable) }
end
