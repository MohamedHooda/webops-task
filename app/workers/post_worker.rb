class PostWorker
  include Sidekiq::Worker

  def perform(id)
    # Do something
    puts "heyy testing".inspect
    post = Post.find_by(id:id)
    post.destroy
  end
end
