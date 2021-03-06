class Roster < ApplicationRecord
	has_many :tasks, dependent: :destroy
	has_many :users, -> { distinct }, through: :tasks

	validates :title, 			presence: true
	validates :start_date, 	presence: true
	validate  :must_start_after_today

	def clone
		new_start_date = self.start_date + 7*self.duration
		new_roster = Roster.new(title: self.title, start_date: new_start_date, duration: self.duration, description: self.description)
		new_roster.save
	end

	private
		def must_start_after_today
			if !self.start_date || self.start_date <= Date.today
				errors.add(:start_date, "must be in the future (after today)")
			end
		end
end
