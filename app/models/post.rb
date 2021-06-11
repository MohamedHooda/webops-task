class Post < ApplicationRecord
    has_one :user, foreign_key: 'author_id'
    has_many :comment, :dependent => :destroy
end
