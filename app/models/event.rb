class Event < ApplicationRecord
  belongs_to :admin, class_name: "User"
  has_many :attendances
  has_many :users, through: :attendances
  
 
  #validates :start_date, presence: true
  validates :duration, presence: true
  validates :title,  presence: true, length:  { in: 5..140 }
  validates :description, presence: true, length: { in: 20..1000 }
  validates :price, presence: true, inclusion: 1..1000
  validates :location, presence: true

  #validate :no_start_date_in_the_past
  #validate :duration_format




  


  private
   
  #def no_start_date_in_the_past
   #errors.add(:start_date, "can't be in the past") unless
    #start_date < DateTime.now
 # end

  


end

