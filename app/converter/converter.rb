class Converter
  attr_reader :t, :posts
  def initialize(params)
    Tumblr.configure do |config|
      config.consumer_key = ENV['tumblr_key']
      config.consumer_secret = ENV['tumblr_secret']
      config.oauth_token = params['oauth_token']
      config.oauth_token_secret = params['oauth_token_secret'] 
    end
    @t = Tumblr::Client.new
  end

  def info
    t.info
  end

  def parse_posts(blog_name=t.info['user']['name'], limit=0)
    @posts = t.posts(blog_name, limit:limit)['posts'].map do |post|
      Post.new(post)
    end
  end

  def save_posts
    posts.each do |post|
      File.open("#{post.slug}.md", 'w') do |file| 
        file.write(post.to_scriptogram)
      end
    end
  end

  def get_all_posts_in_md
    posts.map { |post| post.to_scriptogram }
  end
  
end

class Post

  attr_reader :blog_name, :slug, :type, :date, :title, :body

  def initialize(post_as_json)
    @blog_name = post_as_json['blog_name']
    @slug = post_as_json['slug']
    @type = post_as_json['type']
    @date = DateTime.parse(post_as_json['date'])
    @title = post_as_json['title']
    @body = post_as_json['body']
  end

  def to_scriptogram(options={})
    text_file = []
    text_file += parse_options(options)
    text_file << "\n"
    text_file << to_md(body)
    text_file.join("\n")
  end

  def parse_options(options)
    defaults = {title: title,
                date:date.strftime('%Y-%m-%d'),
                published:true, 
                slug:slug}
    defaults.merge(options).map do |key, value|
      "#{key.to_s.capitalize}: #{value.to_s}"
    end
  end

  def to_md(html)
    HTMLPage.new(contents: html).markdown
  end

end