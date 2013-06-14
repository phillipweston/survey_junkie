get '/surveys/new' do
  # crazy ajax/jquery shit
  erb :create_survey
end

post '/surveys/:id' do
  p params
  user = current_user
  user.choices << Choice.find(params[:id])
  if !user.valid?
    @errors=user.errors
    p @errors
    # go back to :take_survey and deal with errors
  else
    erb :thank_you
  end
end

post '/surveys' do
  Survey.publish(current_user.id, params)
  redirect '/surveys/new'
end

get '/surveys/:id' do
  # note: need to deal with the case where a creator with a valid
  # session responds to a survey responder URL
  @survey=Survey.find(params[:id])
  if current_user == @survey.user
    erb :survey_results
  else
    # collect all choices by survey.questions and summarize
    erb :take_survey
  end
end

get 'surveys/thank-you' do
  # static thank you page + create your own survey button
  erb :thank_you
end
