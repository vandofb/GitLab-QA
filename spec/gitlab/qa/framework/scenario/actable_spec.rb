describe Gitlab::QA::Framework::Scenario::Actable do
  subject do
    Class.new do
      include Gitlab::QA::Framework::Scenario::Actable

      attr_accessor :something

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

    it 'supports passing variables' do
      result = subject.act('thing') do |variable|
        do_something(variable)
      end

      expect(result).to eq 'something'
    end

    it 'returns value from the last method' do
      result = subject.act { 'test' }

      expect(result).to eq 'test'
    end
  end

  describe '.perform' do
    it 'makes it possible to pass binding' do
      variable = 'something'

      result = subject.perform do |object|
        object.something = variable
      end

      expect(result).to eq 'something'
    end

    context 'when class implements #perform' do
      subject do
        Class.new do
          include Gitlab::QA::Framework::Scenario::Actable

          attr_reader :thing1, :thing2

          def do_something(arg = nil)
            @thing1 = "something"
          end

          def perform(arg = nil)
            @thing2 = "someone"
          end
        end
      end

      it 'calls #perform' do
        result = subject.perform do |object|
          object.do_something
          object
        end

        expect(result.thing1).to eq 'something'
        expect(result.thing2).to eq 'someone'
      end
    end
  end
end
