describe Gitlab::QA::Component::Staging do
  describe Gitlab::QA::Component::Staging::Version do
    subject { described_class.new('http://foo') }

    describe '#major_minor_revision' do
      it 'return minor and major version components plus revision' do
        allow(subject).to receive(:fetch!).and_return({ "version" => "12.1.0-pre", "revision" => "f4ed9f5028f" })

        expect(subject.major_minor_revision).to eq("12.1-f4ed9f5028f")
      end
    end
  end
end
