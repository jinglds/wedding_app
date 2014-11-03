json.shop do
  json.id @shop.id
  json.name @shop.name
  json.shop_type @shop.shop_type
  json.price_range @shop.price_range
  json.description @shop.description
  json.phone @shop.phone
  json.email @shop.email
  json.address @shop.address
  json.details @shop.details
  json.rating @ratings
  json.user_id @shop.user ? @shop.user.id : nil

  json.comments @comments do |comment|
  	json.content comment.content
  	json.commenter comment.user.firstname
  end

end