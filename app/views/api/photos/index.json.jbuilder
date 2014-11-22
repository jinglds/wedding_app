json.photos @photos do |photo|
  json.id photo.id
  json.image_url photo.image.url
  json.cover photo.cover
end
