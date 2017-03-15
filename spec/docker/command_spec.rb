describe Gitlab::QA::Docker::Command do
  describe '#<<' do
    it 'appends command arguments' do
      subject << '--help'

      expect(subject.args).to include '--help'
    end

    it 'returns self' do
      expect(subject << 'args').to eq subject
    end
  end

  describe 'execute!' do
    before do
      allow(subject).to receive(:engine)
    end

    it 'calls docker engine method' do
      expect(subject).to receive(:engine)

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
