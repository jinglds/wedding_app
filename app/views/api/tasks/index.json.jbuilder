json.tasks @tasks do |task|
  json.id task.id
  json.title task.title
  json.due_date task.due_date
  json.completed task.completed
  json.note task.note
  json.user_id task.user ? task.user.id : nil
end

