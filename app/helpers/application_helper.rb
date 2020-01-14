module ApplicationHelper
  def new_table_header(new_path)
    link_to '<i class="fa fa-plus fa-lg" aria-hidden="true"></i>'.html_safe, new_path, class: "btn btn-primary"
  end
end
