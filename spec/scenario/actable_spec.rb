describe QA::Scenario::Actable do
  subject do
    Class.new do
      extend QA::Scenario::Actable

      def do_something(arg = nil)
        "some#{arg}"
      end
    end
  end

  describe '.act' do
    it 'provides means to run steps' do
      result = subject.act { do_something }

      expect(result).to eq 'some'
    end

    it 'supports passing arguments' do
      result = subject.act('thing') do |arg|
        do_something(arg)
      end

      expect(result).to eq 'something'
    end
  end
end
