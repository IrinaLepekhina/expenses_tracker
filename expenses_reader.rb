if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require "rexml/document"
require "date"
current_path = File.dirname(__FILE__)

file_name = current_path + '/data/my_expenses.xml'
abort "Файл не найден" unless File.exists?(file_name)

file = File.new(file_name)
doc = REXML::Document.new(file)
file.close

amount_by_day = Hash.new

doc.each_element("expenses/expense") do |expense_node|
  loss_sum = expense_node.elements["amount"].text.to_i
  loss_date = Date.parse(expense_node.elements["date"].text)

  amount_by_day[loss_date] ||=0
  amount_by_day[loss_date] +=loss_sum
end

sum_by_month = Hash.new
current_month = amount_by_day.keys.sort[0].strftime("%B %Y")

amount_by_day.keys.sort.each do |key|
  sum_by_month[key.strftime("%B %Y")] ||=0
  sum_by_month[key.strftime("%B %Y")] += amount_by_day[key]
end

puts "#{current_month} потрачено #{sum_by_month[current_month]}"

amount_by_day.keys.sort.each do |key|
  if key.strftime("%B %Y") != current_month
    current_month = key.strftime("%B %Y")
    puts "#{current_month} потрачено #{sum_by_month[current_month]}"
  end
  puts "\t#{key.day}: #{amount_by_day[key]}"
end
