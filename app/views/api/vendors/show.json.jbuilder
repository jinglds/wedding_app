json.vendor do
  json.id @vendor.id
  json.name @vendor.name.titleize
  json.event_id @vendor.event_id
  json.shop_id @vendor.shop_id
  json.task_id @vendor.task_id
  json.phone @vendor.phone
  json.address @vendor.address
  json.email @vendor.email
  json.contact @vendor.contact
  json.note @vendor.note
end

 