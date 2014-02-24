module SortableHelper
  def sortable(models, call = nil)
    @sortable = models.inject({}) do |sortable, object|
      key = object.send(call) if call
      sortable.merge(key => "#{object.class}_#{object.id}")
    end
    call ? models.map(&call) : models
  end

  def sortable_id(object)
    @sortable && @sortable[object]
  end

  def sortable_fetch(models)
    raise "You must call with block!" unless block_given?
    models.each do |object|
      yield object, "#{object.class}_#{object.id}"
    end
  end
end
