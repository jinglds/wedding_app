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

  if @event.collaborations.any?
    json.owner @event.user.firstname + " " + @event.user.lastname 
    json.collaborators @event.collaborations do |u| 
              json.user_id u.user.id
              json.name u.user.firstname + " " + u.user.lastname
    end
  end
  

end