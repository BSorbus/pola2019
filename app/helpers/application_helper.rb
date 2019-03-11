module ApplicationHelper

  # for layouts/messages
  def flash_class_name(name)
    case name
    when 'notice' then 'success'
    when 'alert'  then 'danger'
    when 'error'  then 'danger'
    else name
    end
  end

  # display error layout
  def form_errors_for(object=nil)
    if object.present? && object.errors.any?
      render('layouts/errors', object: object)
    end
  end

  def text_with_break_line(text_data)
    Loofah.fragment(text_data.gsub("\r\n", "<br>")).scrub!(:strip).to_s.html_safe
  end
  
  # for nested_attribute
  def link_to_add_fields(name, f, association, opts={})
    # creaate a new object given the form object, and the association name
    new_object = f.object.class.reflect_on_association(association).klass.new

    # call the fields_for function and render the fields_for to a string
    # child index is set to "new_#{association}, which would then later
    # be replaced in in javascript function add_fields
    fields = f.fields_for(association,
        new_object,
        :child_index => "new_#{association}") do |builder|
      # render partial: _task_fields.html.erb
      render(association.to_s.singularize + "_fields", f: builder)
    end

    # call link_to_function to transform to a HTML link
    # clicking this link will then trigger add_fields javascript function
    link_to_function(name,
      h("add_fields(this,
        \"#{association}\", \"#{escape_javascript(fields)}\");return false;"),
      class: 'btn btn-success pull-right')
  end

  def link_to_function(name, js, opts={})
    link_to name, '#', opts.merge({onclick: js})
  end
  
end
