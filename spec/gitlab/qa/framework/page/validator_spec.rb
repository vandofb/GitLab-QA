describe Gitlab::QA::Framework::Page::Validator do
  before do
    stub_const('Gitlab::QA::Framework::Test', Module.new)
    stub_const('Gitlab::QA::Framework::Test::APage', Class.new(Gitlab::QA::Framework::Page::Base) { view('lib/gitlab/qa.rb') { element :button, 'module Gitlab' } })
    stub_const('Gitlab::QA::Framework::Test::AModule', Module.new)
    stub_const('Gitlab::QA::Framework::Test::AModule::APage', Class.new(Gitlab::QA::Framework::Page::Base) { view('lib/gitlab/qa.rb') { element :button, 'module Gitlab' } })
  end
  describe '#constants' do
    subject do
      described_class.new(Gitlab::QA::Framework::Test)
    end

    it 'returns all constants that are module children' do
      expect(subject.constants)
        .to include Gitlab::QA::Framework::Test::APage, Gitlab::QA::Framework::Test::AModule
    end
  end

  describe '#descendants' do
    subject do
      described_class.new(Gitlab::QA::Framework::Test)
    end

    it 'recursively returns all descendants that are page objects' do
      expect(subject.descendants)
        .to include Gitlab::QA::Framework::Test::APage, Gitlab::QA::Framework::Test::AModule::APage
    end

    it 'does not return modules that aggregate page objects' do
      expect(subject.descendants)
        .not_to include Gitlab::QA::Framework::Test::AModule
    end
  end

  context 'when checking validation errors' do
    let(:view) { spy('view') }

    before do
      allow(Gitlab::QA::Framework::Test::AModule::APage)
        .to receive(:views).and_return([view])
    end

    subject do
      described_class.new(Gitlab::QA::Framework::Test)
    end

    context 'when there are no validation errors' do
      before do
        allow(view).to receive(:errors).and_return([])
      end

      describe '#errors' do
        it 'does not return errors' do
          expect(subject.errors).to be_empty
        end
      end

      describe '#validate!' do
        it 'does not raise error' do
          expect { subject.validate! }.not_to raise_error
        end
      end
    end

    context 'when there are validation errors' do
      before do
        allow(view).to receive(:errors)
          .and_return(['some error', 'another error'])
      end

      describe '#errors' do
        it 'returns errors' do
          expect(subject.errors.count).to eq 2
        end
      end

      describe '#validate!' do
        it 'raises validation error' do
          expect { subject.validate! }
            .to raise_error described_class::ValidationError
        end
      end
    end
  end
end
