module ApplicationHelper
  def new_table_header(path)
    link_to '<i class="fa fa-plus" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  end

  def edit_button(path)
    link_to '<i class="fa fa-pencil fa-lg" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  end

  def index_button(path)
    link_to '<i class="fa fa-arrow-left" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  end

  def delete_button(path)
    link_to '<i class="fa fa-trash-o fa-lg" aria-hidden="true"></i>'.html_safe, path, method: :delete,
      class: "btn btn-sm btn-danger", data: { confirm: 'Você tem certeza?' }
  end

  def online_button(up)
    if up
      "btn-success"
    else
      "btn-danger"
    end
  end

end
