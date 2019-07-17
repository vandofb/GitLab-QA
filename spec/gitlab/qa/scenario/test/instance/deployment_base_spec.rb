describe Gitlab::QA::Scenario::Test::Instance::DeploymentBase do
  let(:specs) { spy('Gitlab::QA::Component::Specs') }
  let(:component) { Component }

  class Component
    ADDRESS = 'http://foo'.freeze

    def self.release; end
  end

  subject do
    Class.new(Gitlab::QA::Scenario::Test::Instance::DeploymentBase) do
      def deployment_component; end
    end.new
  end

  describe '#perform' do
    before do
      stub_const('Gitlab::QA::Component::Specs', specs)
      allow(specs).to receive(:perform).and_yield(specs)
      allow(release).to receive(:dev_gitlab_org?).and_return(false)
      allow(subject).to receive(:deployment_component).and_return(component)
      allow(Gitlab::QA::Runtime::Env).to receive(:require_no_license!)
    end

    context 'with no release specified' do
      shared_examples 'component specs' do |args|
        let(:release) { Gitlab::QA::Release.new('gitlab/gitlab-ce:release') }
        let(:args) { [] }

        before do
          allow(component).to receive(:release).and_return(release)
        end

        it 'uses the deployment component release' do
          subject.perform(nil, args)

          expect(release.release).to eq('gitlab/gitlab-ce:release')
          expect(specs).to have_received(:release=).with(release)
          expect(specs).to have_received(:args=).with(['http://foo', args])
        end
      end

      it_behaves_like 'component specs'

      context 'with a non-rspec arg' do
        it_behaves_like 'component specs', %w[--enable-feature foo]
      end

      context 'with rspec args' do
        it_behaves_like 'component specs', %w[-- --tag foo]
      end

      context 'with non-rspec args and rspec args' do
        it_behaves_like 'component specs', %w[--enable-feature foo -- --tag foo]
      end
    end

    context 'with a release specified' do
      shared_examples 'component specs' do |args|
        let(:release) { spy('Gitlab::QA::Release') }

        before do
          stub_const('Gitlab::QA::Release', release)
        end

        it 'uses the specified release and args' do
          subject.perform('another-release', args)

          expect(release).to have_received(:new).with('another-release')
          expect(specs).to have_received(:release=).with(release)
          expect(specs).to have_received(:args=).with(['http://foo', args])
        end
      end

      it_behaves_like 'component specs'

      context 'with a non-rspec option' do
        it_behaves_like 'component specs', %w[--enable-feature foo]
      end

      context 'with rspec args' do
        it_behaves_like 'component specs', %w[-- --tag foo]
      end

      context 'with non-rspec args and rspec args' do
        it_behaves_like 'component specs', %w[--enable-feature foo -- --tag foo]
      end
    end
  end
end
