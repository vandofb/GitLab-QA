describe Gitlab::QA::Docker::Gitlab do
  let(:full_ce_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ce' }
  let(:full_ce_address_with_complex_tag) { "#{full_ce_address}:omnibus-7263a2" }

  describe '#release' do
    context 'whith no release' do
      it 'defaults to CE' do
        expect(subject.release.to_s).to eq 'gitlab/gitlab-ce:nightly'
      end
    end
  end

  describe '#release=' do
    before do
      subject.release = release
    end

    context 'when release is a Release object' do
      let(:release) { create_release('CE') }

      it 'returns a correct release' do
        expect(subject.release.to_s).to eq 'gitlab/gitlab-ce:nightly'
      end
    end

    context 'when release is a string' do
      context 'with a simple tag' do
        let(:release) { full_ce_address_with_complex_tag }

        it 'returns a correct release' do
          expect(subject.release.to_s).to eq full_ce_address_with_complex_tag
        end
      end
    end
  end

  describe '#name' do
    before do
      subject.release = create_release('EE')
    end

    it 'returns a unique name' do
      expect(subject.name).to match(/\Agitlab-qa-ee-(\w+){8}\z/)
    end
  end

  describe '#hostname' do
    it { expect(subject.hostname).to match(/\Agitlab-qa-ce-(\w+){8}\.\z/) }

    context 'with a network' do
      before do
        subject.network = 'local'
      end

      it 'returns a valid hostname' do
        expect(subject.hostname).to match(/\Agitlab-qa-ce-(\w+){8}\.local\z/)
      end
    end
  end

  describe '#address' do
    context 'with a network' do
      before do
        subject.network = 'local'
      end

      it 'returns a HTTP address' do
        expect(subject.address)
          .to match(%r{http://gitlab-qa-ce-(\w+){8}\.local\z})
      end
    end
  end

  def create_release(release)
    Gitlab::QA::Release.new(release)
  end
end
