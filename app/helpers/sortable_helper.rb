module SortableHelper
  def sortable(object)
    @sortable[object]
  end

  def sortable_fetch(models)
    raise "You must call with block!" unless block_given?
    models.each do |object|
      yield object, "#{object.class}_#{object.id}"
    end
  end

  private

  def sortable_set(models)
    @sortable ||= models.inject({}) do |sortable, object|
      sortable.merge(object => "#{object.class}_#{object.id}")
    end
    models
  end
end
