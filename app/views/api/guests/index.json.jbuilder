json.guests @guests do |guest|
  json.id guest.id
  json.prefix guest.prefix
  json.name guest.name
  json.side guest.side
  json.group guest.group
  json.table_no guest.table_no
  json.adults guest.adults
  json.children guest.children
  json.phone guest.phone
  json.address  guest.address
  json.gender  guest.gender
  json.status  guest.status
  json.note  guest.note
end
