module RailsSortable
  module Model
    extend ActiveSupport::Concern

    #
    # Include this module to your ActiveRecord model.
    # And you must call `set_sortable` method for using sortable model.
    #
    # ex)
    # class SampleModel < ActiveRecord::Base
    #   include RailsSortable::Model
    #   set_sortable :sort, silence_recording_timestamps: true, :new => :minimize
    # end
    #
    included do
      def update_sort!(new_value)
        write_attribute sort_attribute, new_value
        if sortable_options[:silence_recording_timestamps]
          silence_recording_timestamps { save! }
        else
          save!
        end
      end

      def maximize
        return if read_attribute(sort_attribute)
        write_attribute sort_attribute, max_sort
      end

      def minimize
        return if read_attribute(sort_attribute)
        write_attribute sort_attribute, min_sort
      end

      protected

      def silence_recording_timestamps
        raise ArgumentError unless block_given?
        original_record_timestamps = self.class.record_timestamps
        self.class.record_timestamps = false
        yield
        self.class.record_timestamps = original_record_timestamps
      end

      def max_sort
        (self.class.maximum(sort_attribute) || 0) + 1
      end

      def min_sort
        (self.class.minimum(sort_attribute) || 0) - 1
      end
    end

    module ClassMethods
      #
      # allowed options
      # - silence_recording_timestamps
      #     When it is true, timestamp(updated_at) will be NOT modified with reordering.
      #
      def set_sortable(attribute, options = {})
        define_method("sort_attribute") { attribute }
        before_create options[:new] || :maximize
        define_method("sortable_options") { options }
      end
    end
  end
end
