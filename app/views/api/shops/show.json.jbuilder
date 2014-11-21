json.shop do
  json.id @shop.id
  json.name @shop.name
  json.price_range @shop.price_range
  json.description @shop.description
  json.phone @shop.phone
  json.email @shop.email
  json.address @shop.address
  json.details @shop.details
  json.rating @ratings
  json.favorite @favorite ? true : false
  json.category_list @shop.category_list
  json.style_list @shop.style_list


end