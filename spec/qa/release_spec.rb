describe Gitlab::QA::Release do
  let(:full_ce_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ce' }
  let(:full_ce_address_with_simple_tag) { "#{full_ce_address}:latest" }
  let(:full_ce_address_with_complex_tag) { "#{full_ce_address}:omnibus-7263a2" }
  let(:full_ee_address) { 'registry.gitlab.com/foo/gitlab/gitlab-ee' }
  let(:full_ee_address_with_simple_tag) { "#{full_ee_address}:latest" }
  let(:full_ee_address_with_complex_tag) { "#{full_ee_address}:omnibus-7263a2" }

  describe '#to_s' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.to_s).to eq 'gitlab/gitlab-ce:nightly' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.to_s).to eq 'gitlab/gitlab-ee:nightly' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.to_s).to eq full_ce_address_with_simple_tag }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.to_s).to eq full_ce_address_with_complex_tag }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.to_s).to eq full_ee_address_with_simple_tag }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.to_s).to eq full_ee_address_with_complex_tag }
      end
    end
  end

  describe '#previous_stable' do
    context 'when release is CE' do
      subject { described_class.new('CE').previous_stable }

      it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
      it { expect(subject.tag).to eq 'latest' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE').previous_stable }

      it { expect(subject.image).to eq 'gitlab/gitlab-ee' }
      it { expect(subject.tag).to eq 'latest' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject do
          described_class.new(full_ce_address_with_simple_tag).previous_stable
        end

        it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject do
          described_class.new(full_ce_address_with_complex_tag).previous_stable
        end

        it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
        it { expect(subject.tag).to eq 'latest' }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject do
          described_class.new(full_ee_address_with_simple_tag).previous_stable
        end

        it { expect(subject.image).to eq 'gitlab/gitlab-ee' }
        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject do
          described_class.new(full_ee_address_with_complex_tag).previous_stable
        end

        it { expect(subject.image).to eq 'gitlab/gitlab-ee' }
        it { expect(subject.tag).to eq 'latest' }
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

  describe '#canonical_image' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ce' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ee' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ce' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ce' }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ee' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.canonical_image).to eq 'gitlab/gitlab-ee' }
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
