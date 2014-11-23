json.comments @comments do |comment|
	json.title comment.title
  	json.content comment.content
  	json.commenter comment.user.firstname
  	json.likes comment.cached_votes_score
  	json.created_at comment.created_at
  	json.shop_rating comment.user.votes.find_by(:votable_id => @shop.id) ? comment.user.votes.find_by(:votable_id => @shop.id).vote_weight : nil
  end