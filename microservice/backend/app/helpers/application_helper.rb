module ApplicationHelper
  def generate_code(len)
    [*('a'..'z'), *('0'..'9'), *('A'..'Z')].shuffle[0, len].join
  end

  def format_date(date)
    if date
      date.strftime('%d/%m/%Y %H:%M:%S')
    else
      '-'
    end
  end

  def format_yes_no(condition)
    if condition
      'Yes'
    else
      'No'
    end
  end
end
