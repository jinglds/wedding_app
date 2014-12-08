json.myevents @events do |event|
  json.id event.id
  json.name event.name
  json.event_type event.event_type
  json.date event.date
  json.budget event.budget
  json.bride_name event.bride_name
  json.groom_name event.groom_name 
  json.user_id event.user ? event.user.id : nil
  if event.collaborations.any?
  	json.owner event.user.firstname + " " + event.user.lastname 
    json.collaborators event.collaborations do |u| 
              json.user_id u.user.id
              json.name u.user.firstname + " " + u.user.lastname
    end
  end
end

json.collaborations @collaborations do |collaboration|
	json.id collaboration.id
  json.name collaboration.name
  json.event_type collaboration.event_type
  json.date collaboration.date
  json.budget collaboration.budget
  json.bride_name collaboration.bride_name
  json.groom_name collaboration.groom_name
  json.user_id collaboration.user ? collaboration.user.id : nil
  if collaboration.collaborations.any?
  	json.owner collaboration.user.firstname + " " + collaboration.user.lastname 
    json.collaborators collaboration.collaborations do |u| 
              json.user_id u.user.id
              json.name u.user.firstname + " " + u.user.lastname

    end
  end
end

json.requests @requests do |request|
	json.id request.id
  json.name request.name
  json.event_type request.event_type
  json.date request.date
  json.budget request.budget
  json.bride_name request.bride_name
  json.groom_name request.groom_name
  json.user_id request.user ? request.user.id : nil
  if request.collaborations.any?
  	json.owner request.user.firstname + " " + request.user.lastname 
    json.collaborators request.collaborations do |u| 
              json.user_id u.user.id
              json.name u.user.firstname + " " + u.user.lastname
    end
  end
end

