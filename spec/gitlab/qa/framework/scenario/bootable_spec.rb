describe Gitlab::QA::Framework::Scenario::Bootable do
  subject do
    Class.new
      .include(Gitlab::QA::Framework::Scenario::Actable)
      .include(described_class)
  end

  it 'makes it possible to define the scenario attribute' do
    subject.class_eval do
      attribute :something, '--something SOMETHING', desc: 'Some attribute'
      attribute :another, '--another ANOTHER', desc: 'Some other attribute'
      attribute :bool, '--bool', type: :flag, desc: 'A boolean attribute'
      attribute :attr_with_default, '--foo', default: 'hello world'
    end

    expect(subject).to receive(:perform)
      .with(something: 'test', another: '42', bool: true, attr_with_default: 'hello world')

    subject.launch!(%w[--another 42 --something test --bool])
  end

  it 'does not require attributes to be defined' do
    expect(subject).to receive(:perform).with('some', 'argv')

    subject.launch!(%w[some argv])
  end
end
