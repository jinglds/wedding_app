json.task do
  json.id @task.id
  json.id @task.id
  json.title @task.title
  json.due_date @task.due_date
  json.completed @task.completed
  json.note @task.note

  json.vendor do 
  	@vendor ? 
  	(json.id @vendor.id
  	json.name @vendor.name
  	json.phone @vendor.phone
  	json.email @vendor.email
  	json.contact @vendor.contact
  	json.note @vendor.note) : nil
  end

end