json.checklist @checklists do |c|
  json.id c.id
  json.title c.title
  json.time_range c.time_range
  json.completed c.completed

end
