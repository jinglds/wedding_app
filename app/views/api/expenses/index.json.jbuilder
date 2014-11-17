json.expenses @expenses do |expense|
  json.id expense.id
  json.title expense.title
  json.expense_type expense.expense_type
  json.amount expense.amount
  json.receiver expense.receiver
  json.status expense.status
  json.event_id  expense.event_id
end
