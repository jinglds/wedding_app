json.events @tasks do |task|
  json.title task.title
  json.start task.due_date
end
