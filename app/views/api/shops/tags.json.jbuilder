json.styles @styles do |style|
  json.name style.name
  json.count style.count
end

json.categories @categories do |category|
  json.name category.name
  json.count category.count
end