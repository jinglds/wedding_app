json.shops @shops do |shop|
  json.id shop.id
  json.name shop.name.titleize
  json.user_id shop.user ? shop.user.id : nil
end
