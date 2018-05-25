describe Gitlab::QA::Docker::Command do
  let(:docker) { spy('docker') }

  before do
    stub_const('Gitlab::QA::Framework::Docker::Shellout', docker)
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
    it 'appends volume arguments' do
      subject.volume('/from', '/to', 'Z')

      expect(subject.to_s).to include '--volume /from:/to:Z'
    end
  end

  describe '#env' do
    it 'appends env arguments with quotes' do
      subject.env('TEST', 'some value')

      expect(subject.to_s).to include '--env TEST="some value"'
    end
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
