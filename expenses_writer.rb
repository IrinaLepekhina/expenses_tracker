if Gem.win_platform?
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require "rexml/document"
require "date"
include REXML

current_path = File.dirname(__FILE__)
expense_text = "Поездка"
expense_amount = "333"
expense_category = "Отдых"
expense_date = "01.01.2001" 

# puts "на что потратили?"
# expense_text = STDIN.gets.chomp

# puts "сколько?"
# expense_amount = STDIN.gets.chomp.to_i

# puts "категория?"
# expense_categoty = STDIN.gets.chomp.to_i

# puts "когда? в формате 01-01-2001"
# date_input = STDIN.gets.chomp

# if date_input == ""
#   expense_date = Date.today
# else
#   expense_date = Date.parse(date_input)
# end

file_name = current_path + '/data/my_expenses.xml'

begin
file = File.new(file_name, "r:UTF-8")
doc = REXML::Document.new(file)
rescue REXML::ParseException => e
  abort e.message
end

file.close

expense = doc.root.add_element("expense")

expense.add_element("date").text = expense_date
expense.add_element("amount").text = expense_amount
expense.add_element("category").text = expense_category
expense.add_element("text").text = expense_text

file = File.new(file_name, "w:UTF-8")
doc.write(file, 4)
file.close
