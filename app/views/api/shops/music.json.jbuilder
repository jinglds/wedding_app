json.shops @shops do |shop|
  json.id shop.id
  json.name shop.name
  json.shop_type shop.shop_type
  json.user_id shop.user ? shop.user.id : nil
end
