module ApplicationHelper
  def new_table_header(path)
    link_to '<i class="fa fa-plus fa-lg" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-primary"
  end
  def edit_button(path)
    link_to '<i class="fa fa-pencil fa-lg" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-primary"
  end
  def index_button(path)
    link_to '<i class="fa fa-list fa-lg" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-primary"
  end
end
