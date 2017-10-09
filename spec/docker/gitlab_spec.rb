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

  describe '#start' do
    let(:args) { [] }
    let(:command) { spy('docker command') }
    let(:docker) { spy('docker engine') }

    before do
      allow(subject).to receive(:ensure_configured!)

      allow(subject).to receive(:docker) { docker }
      allow(docker).to receive(:run) { |&blk| blk.call command }
      allow(command).to receive(:<<) { |*argv| args.concat(argv) }
    end

    it 'should call Gitlab::QA::Docker::Engine#run' do
      expect(docker).to receive(:run)
      subject.start
    end

    it 'should specify boilerplate switches' do
      subject.start
      expect(args).to include('-d -p 80:80')
    end

    it 'should specify the name' do
      subject.start
      expect(args).to include("--name #{subject.name}")
    end

    it 'should specify the hostname' do
      subject.start
      expect(args).to include("--hostname #{subject.hostname}")
    end

    context 'with a network' do
      before do
        subject.network = 'testing-network'
      end

      it 'should specify the network' do
        subject.start
        expect(args).to include('--net testing-network')
      end
    end

    context 'with volumes' do
      before do
        subject.volumes = { '/from' => '/to' }
      end

      it 'adds --volume switches to the command' do
        subject.start
        expect(args).to include('--volume /from:/to:Z')
      end
    end

    context 'with environment' do
      context 'plain values' do
        before do
          subject.environment = { 'TEST' => 'value' }
        end

        it 'adds --env switches to the command' do
          subject.start
          expect(args).to include('--env TEST=value')
        end
      end

      context 'values with spaces' do
        before do
          subject.environment = { 'TEST' => 'a value with spaces' }
        end

        it 'adds --env shell escaped values' do
          subject.start
          expect(args).to include('--env TEST=a\ value\ with\ spaces')
        end
      end
    end

    context 'with network_aliases' do
      before do
        subject.network_aliases = ['lolcathost']
      end

      it 'adds --network-alias switches to the command' do
        subject.start
        expect(args).to include('--network-alias lolcathost')
      end
    end
  end

  def create_release(release)
    Gitlab::QA::Release.new(release)
  end
end
