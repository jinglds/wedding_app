json.expense do
  json.id @expense.id
  json.title @expense.title
  json.expense_type @expense.expense_type
  json.amount @expense.amount
  json.receiver @expense.receiver
  json.paid @expense.paid
  json.event_id  @expense.event_id
  

end

 