class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, presence: true, inclusion: %w(PENDING APPROVED DENIED)
  validates :does_not_overlap_aproved_request
  
  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: :Cat

  def overlapping_requests
    CatRentalRequest
      .where.not(id: self.id)
      .where(cat_id: cat_id)
      .where(<<-SQL, start_date: start_date, end_date: end_date)
        NOT((start_date > :end_date) OR (end_date < :start_date))
      SQL

  end

  def overlapping_approved_requests
    overlapping_requests.where("status = APPROVED")
  end

  def overlapping_pending_requests
    overlapping_requests.where("status = PENDING")
  end

  def does_not_overlap_aproved_request
    return if self.denied?
    unless overlapping_approved_requests.empty?
      error[:base] << "Sorry, Cat is already taken"
  end

end
