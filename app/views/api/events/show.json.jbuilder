json.event do
  json.id @event.id
  json.name @event.name
  json.event_type @event.event_type
  json.date @event.date
  json.budget @event.budget
  json.bride_name @event.bride_name
  json.groom_name @event.groom_name

  json.total_expenses @total
  json.expenses @expenses.count
  json.tasks @tasks.count
  

end