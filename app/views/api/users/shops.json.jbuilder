json.shops @shops do |shop|
  json.id shop.id
  json.name shop.name
  json.favorites Favorite.where(:favorited_id =>shop.id).count
  json.rating shop.cached_weighted_average
  json.user_id shop.user ? shop.user.id : nil
end

