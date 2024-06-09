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
    if params[:sort] == column.to_s
      direction = params[:direction] == "asc" ? "desc" : "asc"
    else
      direction = "asc"
    end
    link_to name, request.params.merge(sort: column, direction: direction), **options
  end
end
