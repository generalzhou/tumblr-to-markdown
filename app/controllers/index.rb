get '/' do
  @consumer_key = ENV['consumer_key']
  @consumer_secret = ENV['consumer_secret']
  haml :index
end

get '/oauth' do
  @consumer = OAuth::Consumer.new(ENV['tumblr_key'], 
                                  ENV['tumblr_secret'], 
                                  {site: 'http://www.tumblr.com'})
  @request_token = @consumer.get_request_token(:oauth_callback => "#{request.base_url}/authorize")
  session[:request_token] = @request_token
  @request_token.authorize_url
  redirect @request_token.authorize_url
end

get '/authorize' do
  if session[:access_token]
    redirect '/view_posts'
  else
    request_token = session[:request_token]
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    session[:access_token] = access_token
  end
end

get '/view_posts' do
  c = Converter.new(session['access_token'].params)
  @info = c.info
  c.parse_posts
  @posts_as_md = c.get_all_posts_in_md
  haml :view_posts
end
