json.article do
  json.id @article.id
  json.title @article.title
  json.content @article.content
  json.user @article.user.firstname
end

 