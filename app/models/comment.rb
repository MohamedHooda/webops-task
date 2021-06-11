class Comment < ApplicationRecord
    has_one :user, foreign_key: 'author_id'
    has_one :post
end
