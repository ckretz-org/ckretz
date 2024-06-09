module ApplicationHelper
  def turbo_id_for(object:, id_or_hash: false)
    id = if id_or_hash
      object.id
    elsif object.persisted?
      dom_id(object)
    end
    id || object.hash
  end

  def sort_link_to(name, column, **options)
    direction = if params[:sort] == column.to_s
      (params[:direction] == "asc") ? "desc" : "asc"
    else
      "asc"
    end
    link_to name, request.params.merge(sort: column, direction: direction), **options
  end
end
