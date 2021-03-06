json.vendor do
  json.id @vendor.id
  json.name @vendor.name.titleize
  json.shop_id @vendor.shop_id
  json.task_id @vendor.task_id
  json.phone @vendor.phone
  json.address @vendor.address
  json.email @vendor.email
  json.contact @vendor.contact
  json.note @vendor.note

  json.events @vendor.events do |e|
    json.event_id e.id
    json.event_name e.name.titleize
  end

end

 