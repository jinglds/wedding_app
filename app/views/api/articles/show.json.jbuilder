json.article do
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.updated_at @article.updated_at
  json.user @article.user.firstname
end

 