# == Schema Information
#
# Table name: media
#
#  id             :integer          not null, primary key
#  upload         :string
#  transcript     :string
#  public_ref     :boolean
#  education_use  :boolean
#  public_archive :boolean
#  publication    :boolean
#  broadcasting   :boolean
#  editing        :boolean
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  type           :string
#  contributor_id :integer
#
# Indexes
#
#  index_media_on_contributor_id  (contributor_id)
#

class Medium < ActiveRecord::Base
  belongs_to :contributor, autosave: true
  has_many :records, dependent: :destroy, autosave: true

  attr_accessor :type, :text
  accepts_nested_attributes_for :records
  accepts_nested_attributes_for :contributor
  mount_uploader :upload, MediumUploader

  validates :upload, presence: true
  validates :contributor, presence: true
  validates :copyright, :acceptance => true
  validates_presence_of :upload
  validates_presence_of :contributor
  validates_presence_of :records

  # Validates associated bubbling makes associated error messages more readable
  validates_associated_bubbling :records
  validates_associated_bubbling :contributor

  def unapproved_records
    self.records.where(approved: false).order('created_at')
  end

  def approved_records
    self.records.where(approved: true).order('created_at')
  end

  def latest_approved_record
    self.records.where(approved: true).order('created_at').last
  end

  def accepted_mimes
    case self.type
      when'Recording'
        '.wav,.mp3'
      when 'Document'
        '.pdf'
      when 'Image'
        '.jpeg,.jpg,.gif,.tff,.bmp,.png'
      else
        ''
    end
  end

end
