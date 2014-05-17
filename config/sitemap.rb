# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = ENV['HOST_NAME']

SitemapGenerator::Sitemap.create(:compress => false) do
  add posts_path, :priority => 0.7, :changefreq => 'daily'
  add waiting_room_posts_path, :priority => 0.7, :changefreq => 'daily'
  Post.find_each do |post|
    add post_path(post), :lastmod => post.updated_at
  end
  User.find_each do |user|
    add user_path(user), :lastmod => user.posts.last.updated_at
  end
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
