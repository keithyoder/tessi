# frozen_string_literal: true

module ApplicationHelper
  # def new_table_header(path)
  #  link_to '<i class="fa fa-plus" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  # end

  # def edit_button(path)
  #  link_to '<i class="fa fa-pencil fa-lg" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  # end

  # def index_button(path)
  #  link_to '<i class="fa fa-arrow-left" aria-hidden="true"></i>'.html_safe, path, class: "btn btn-sm btn-outline-dark"
  # end

  def online_button(up)
    if up
      'btn-success'
    else
      'btn-danger'
    end
  end

  def num_to_phone(num)
    if num.length == 11
      "(#{num[0..1]}) #{num[2..6]}-#{num[7..]}"
    else
      "(#{num[0..1]}) #{num[2..5]}-#{num[6..]}"
    end
  end

  def novo_botao(resource, params = {})
    return unless defined?(resource) && can?(:create, resource.model)

    link_to({ controller: resource.model_name.plural, params: params, action: :new },
            class: 'd-print-none btn btn-sm btn-outline-dark') do
      '<i class="fas fa-plus" aria-hidden="true"></i>'.html_safe
    end
  end
end
