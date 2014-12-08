json.comments @comments do |comment|
	json.id comment.id
	json.title comment.title
  	json.content comment.content
  	if @user==comment.user
  		json.commenter comment.user.firstname + " (shop owner)"
  	else 
  		json.commenter comment.user.firstname
  	end
  	json.likes comment.cached_votes_score
  	json.created_at comment.created_at
  	json.shop_rating comment.user.votes.find_by(:votable_id => @shop.id) ? comment.user.votes.find_by(:votable_id => @shop.id).vote_weight : nil
  	json.liked_by_user @user.voted_for? comment
  end