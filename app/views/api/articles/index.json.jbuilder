json.articles @articles do |article|
  json.id article.id
  json.title article.title
  json.user article.user.firstname
end
