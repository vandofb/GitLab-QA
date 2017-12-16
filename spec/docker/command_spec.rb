describe Gitlab::QA::Docker::Command do
  let(:docker) { spy('docker') }

  before do
    stub_const('Gitlab::QA::Docker::Shellout', docker)
  end

  describe '#<<' do
    it 'appends command arguments' do
      subject << '--help'

      expect(subject.args).to include '--help'
    end

    it 'returns self' do
      expect(subject << 'args').to eq subject
    end
  end

  describe '#volume' do
    pending
  end

  describe '#env' do
    pending
  end

  describe 'execute!' do
    it 'calls docker engine shellout' do
      expect(docker).to receive(:execute!)

      subject.execute!
    end
  end

  describe '.execute' do
    it 'executes command directly' do
      instance = double('command')
      expect(instance).to receive(:execute!)
      allow(described_class).to receive(:new).and_return(instance)

      described_class.execute('version')
    end
  end
end
