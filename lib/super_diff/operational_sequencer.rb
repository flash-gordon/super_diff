module SuperDiff
  class OperationalSequencer
    extend AttrExtras.mixin

    method_object(
      [
        :expected!,
        :actual!,
        :all_or_nothing!,
        extra_classes: [],
        extra_diff_formatter_classes: [],
      ],
    )

    def call
      if resolved_class
        resolved_class.call(
          expected: expected,
          actual: actual,
          extra_operational_sequencer_classes: extra_classes,
          extra_diff_formatter_classes: extra_diff_formatter_classes,
        )
      elsif all_or_nothing?
        raise NoOperationalSequencerAvailableError.create(expected, actual)
      else
        nil
      end
    end

    private

    attr_query :all_or_nothing?

    def resolved_class
      available_classes.find { |klass| klass.applies_to?(expected, actual) }
    end

    def available_classes
      classes = extra_classes + OperationalSequencers::DEFAULTS

      if all_or_nothing?
        classes + [OperationalSequencers::DefaultObject]
      else
        classes
      end
    end
  end
end
