# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  english     :text
#  phonetic    :text
#  created_at  :datetime
#  updated_at  :datetime
#  picture     :string
#  language_id :integer
#  tsv_data    :tsvector
#  category_id :integer
#  state       :string           default("draft")
#

class Article < ActiveRecord::Base
  include PgSearch

  belongs_to :language
  belongs_to :category
  has_many :audios

  accepts_nested_attributes_for :audios, reject_if: :all_blank, allow_destroy: true

  # default order when calling the Article model
  default_scope -> { order('created_at DESC') }
  default_value_for :state, 0

  # CarrierWave integration for uploading pictures
  mount_uploader :picture, PictureUploader

  validates :picture, presence: true

  # PgSearch
  pg_search_scope :article_search,
                  against: :tsv_data,
                  using: {
                      tsearch: {
                          dictionary: 'english',
                          any_word: true,
                          prefix: true,
                          tsvector_column: 'tsv_data'
                      }
                  }

  enum state:   [:draft, :published]
end
