class PostWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(id, token)
    # Do something
    puts "heyy testing".inspect
    post = Post.find_by(id:id)
    post.destroy
  end
end
