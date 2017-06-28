describe Gitlab::QA::Release do
  let(:full_ce_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ce' }
  let(:full_ce_address_with_tag) { "#{full_ce_address}:latest" }
  let(:full_ee_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ee' }
  let(:full_ee_address_with_tag) { "#{full_ee_address}:latest" }

  describe '#edition' do
    context 'when version_or_image is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.edition).to eq :ce }
    end

    context 'when version_or_image is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.edition).to eq :ee }
    end

    context 'when version_or_image is a full CE address' do
      subject { described_class.new(full_ce_address_with_tag) }

      it { expect(subject.edition).to eq :ce }
    end

    context 'when version_or_image is a full EE address' do
      subject { described_class.new(full_ee_address_with_tag) }

      it { expect(subject.edition).to eq :ee }
    end
  end

  describe '#image' do
    context 'when version_or_image is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
    end

    context 'when version_or_image is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.image).to eq 'gitlab/gitlab-ee' }
    end

    context 'when version_or_image is a full CE address' do
      subject { described_class.new(full_ce_address_with_tag) }

      it { expect(subject.image).to eq full_ce_address }
    end

    context 'when version_or_image is a full EE address' do
      subject { described_class.new(full_ee_address_with_tag) }

      it { expect(subject.image).to eq full_ee_address }
    end
  end

  describe '#tag' do
    context 'when version_or_tag is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.tag).to eq 'nightly' }
    end

    context 'when version_or_tag is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.tag).to eq 'nightly' }
    end

    context 'when version_or_tag is a full CE address' do
      subject { described_class.new(full_ce_address_with_tag) }

      it { expect(subject.tag).to eq 'latest' }
    end

    context 'when version_or_tag is a full EE address' do
      subject { described_class.new(full_ee_address_with_tag) }

      it { expect(subject.tag).to eq 'latest' }
    end
  end
end
