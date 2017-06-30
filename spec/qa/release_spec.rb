describe Gitlab::QA::Release do
  let(:full_ce_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ce' }
  let(:full_ce_address_with_simple_tag) { "#{full_ce_address}:latest" }
  let(:full_ce_address_with_complex_tag) { "#{full_ce_address}:omnibus-7263a2" }
  let(:full_ee_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ee' }
  let(:full_ee_address_with_simple_tag) { "#{full_ee_address}:latest" }
  let(:full_ee_address_with_complex_tag) { "#{full_ee_address}:omnibus-7263a2" }

  describe '.init' do
    context 'when release is a Release' do
      let(:release) { described_class.new('CE') }

      it 'returns the given release' do
        expect(described_class.init(release)).to eq release
      end
    end

    context 'when release is a string' do
      let(:release) { 'CE' }

      it 'creates a new Release object' do
        expect(described_class.init(release)).to be_a described_class
      end
    end
  end

  describe '#edition' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.edition).to eq :ce }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.edition).to eq :ee }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.edition).to eq :ce }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.edition).to eq :ce }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.edition).to eq :ee }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.edition).to eq :ee }
      end
    end
  end

  describe '#image' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.image).to eq 'gitlab/gitlab-ee' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.image).to eq full_ce_address }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.image).to eq full_ce_address }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.image).to eq full_ee_address }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.image).to eq full_ee_address }
      end
    end
  end

  describe '#tag' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.tag).to eq 'nightly' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.tag).to eq 'nightly' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.tag).to eq 'omnibus-7263a2' }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.tag).to eq 'omnibus-7263a2' }
      end
    end
  end
end
