class BlogPost < ActiveRecord::Base
  belongs_to :account
  validates_presence_of :title
  validates_presence_of :body

  def excerpt
    body.gsub(/<\/?[^>]*>/, "").gsub(/\n|\r/, "")[0..200] + "..."
  end
end
