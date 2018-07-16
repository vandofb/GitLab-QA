describe Gitlab::QA::Release do
  let(:specific_ce_tag) { '10.8.4-ce.0' }
  let(:specific_ce_qa_tag) { '10.8.4-ce' }
  let(:specific_ee_tag) { '11.0.0-rc5.ee.1' }
  let(:specific_ee_qa_tag) { '11.0.0-rc5-ee' }
  let(:full_ce_address) { 'registry.gitlab.com:5000/foo/gitlab/gitlab-ce' }
  let(:full_ce_address_with_simple_tag) { "#{full_ce_address}:latest" }
  let(:full_ce_address_with_complex_tag) { "#{full_ce_address}:#{specific_ce_tag}" }
  let(:full_ee_address) { 'registry.gitlab.com:5000/foo/gitlab/gitlab-ee' }
  let(:full_ee_address_with_simple_tag) { "#{full_ee_address}:latest" }
  let(:full_ee_address_with_complex_tag) { "#{full_ee_address}:#{specific_ee_tag}" }
  let(:full_dev_address) { 'dev.gitlab.org:5005/gitlab/omnibus-gitlab/gitlab-ee:latest' }

  describe '#to_s' do
    context 'when release is ce' do
      subject { described_class.new('ce') }

      it { expect(subject.to_s).to eq 'gitlab/gitlab-ce:nightly' }
    end

    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.to_s).to eq 'gitlab/gitlab-ce:nightly' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.to_s).to eq 'gitlab/gitlab-ee:nightly' }
    end

    context 'when release is EDITION:tag' do
      subject { described_class.new("CE:#{specific_ce_tag}") }

      it { expect(subject.to_s).to eq "gitlab/gitlab-ce:#{specific_ce_tag}" }
    end

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.to_s).to eq "gitlab/gitlab-ce:#{specific_ce_tag}" }
    end

    context 'when release is a full CE address' do
      context 'without a tag' do
        subject { described_class.new(full_ce_address) }

        it { expect(subject.to_s).to eq full_ce_address_with_simple_tag }
      end

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

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
      it { expect(subject.tag).to eq specific_ce_tag }
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

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.edition).to eq :ce }
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

  describe '#ee?' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject).not_to be_ee }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject).to be_ee }
    end

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject).not_to be_ee }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject).not_to be_ee }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject).not_to be_ee }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject).to be_ee }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject).to be_ee }
      end
    end
  end

  describe '#to_ee' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.to_ee.to_s).to eq 'gitlab/gitlab-ee:nightly' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.to_ee.to_s).to eq subject.to_s }
    end

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.to_ee.to_s).to eq "gitlab/gitlab-ee:#{specific_ce_tag}" }
    end

    context 'when tag includes `ce`' do
      subject { described_class.new('CE:abcdcef') }

      it { expect(subject.to_ee.to_s).to eq 'gitlab/gitlab-ee:abcdcef' }
    end

    context 'when tag includes `ee`' do
      subject { described_class.new('CE:abcdeef') }

      it { expect(subject.to_ee.to_s).to eq 'gitlab/gitlab-ee:abcdeef' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.to_ee.to_s).to eq full_ee_address_with_simple_tag }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.to_ee.to_s).to eq "#{full_ee_address}:#{specific_ce_tag}" }
      end

      context 'with `ce` in the address outside of the image' do
        let(:ce_image) { 'registry.gitlab.com/cef/gitlab/gitlab-ce:latest' }
        let(:ee_image) { 'registry.gitlab.com/cef/gitlab/gitlab-ee:latest' }

        subject { described_class.new(ce_image) }

        it { expect(subject.to_ee.to_s).to eq ee_image }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.to_ee.to_s).to eq subject.to_s }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.to_ee.to_s).to eq subject.to_s }
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

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.image).to eq 'gitlab/gitlab-ce' }
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

  describe '#qa_image' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.qa_image).to eq 'gitlab/gitlab-ce-qa' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.qa_image).to eq 'gitlab/gitlab-ee-qa' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.qa_image).to eq "#{full_ce_address}-qa" }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.qa_image).to eq "#{full_ce_address}-qa" }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.qa_image).to eq "#{full_ee_address}-qa" }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.qa_image).to eq "#{full_ee_address}-qa" }
      end
    end
  end

  describe '#project_name' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.project_name).to eq 'gitlab-ce' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.project_name).to eq 'gitlab-ee' }
    end

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.project_name).to eq 'gitlab-ce' }
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

    context 'when release is edition:tag' do
      subject { described_class.new("ce:#{specific_ce_tag}") }

      it { expect(subject.tag).to eq specific_ce_tag }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.tag).to eq specific_ce_tag }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.tag).to eq specific_ee_tag }
      end
    end
  end

  describe '#qa_tag' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject.qa_tag).to eq 'nightly' }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject.qa_tag).to eq 'nightly' }
    end

    context 'when release is a full CE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ce_address_with_simple_tag) }

        it { expect(subject.qa_tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ce_address_with_complex_tag) }

        it { expect(subject.qa_tag).to eq specific_ce_qa_tag }
      end
    end

    context 'when release is a full EE address' do
      context 'with a simple tag' do
        subject { described_class.new(full_ee_address_with_simple_tag) }

        it { expect(subject.qa_tag).to eq 'latest' }
      end

      context 'with a complex tag' do
        subject { described_class.new(full_ee_address_with_complex_tag) }

        it { expect(subject.qa_tag).to eq specific_ee_qa_tag }
      end
    end

    context 'when tag is already in the good form' do
      context 'with a simple tag' do
        subject { described_class.new('ce:11.0.8-rc8-ee') }

        it { expect(subject.qa_tag).to eq '11.0.8-rc8-ee' }
      end
    end
  end

  describe '#dev_gitlab_org?' do
    context 'when release is CE' do
      subject { described_class.new('CE') }

      it { expect(subject).not_to be_dev_gitlab_org }
    end

    context 'when release is EE' do
      subject { described_class.new('EE') }

      it { expect(subject).not_to be_dev_gitlab_org }
    end

    context 'when release is a full address from non-dev' do
      subject { described_class.new(full_ce_address_with_simple_tag) }

      it { expect(subject).not_to be_dev_gitlab_org }
    end

    context 'when release is a full address from dev' do
      subject { described_class.new(full_dev_address) }

      it { expect(subject).to be_dev_gitlab_org }
    end
  end
end
