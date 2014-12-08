json.pictures @pictures do |picture|
  json.id picture.id
  json.image_url picture.image.url
  json.cover picture.cover
end
