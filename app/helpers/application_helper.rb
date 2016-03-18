module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    if (column == sort_column && sort_direction == 'asc')
      title +=  ' ↓'
    elsif (column == sort_column)
      title += ' ↑'
    end
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {sort: column, direction: direction}, {class: css_class}
  end
end
