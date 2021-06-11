class PostWorker
  include Sidekiq::Worker

  def perform(id)
    # Do something
    post = Post.find_by(id:id)
    post.destroy
  end
end
