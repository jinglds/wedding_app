json.comments @comments do |comment|
	json.title comment.title
  	json.content comment.content
  	json.commenter comment.user.firstname
  	json.created_at comment.created_at
  end