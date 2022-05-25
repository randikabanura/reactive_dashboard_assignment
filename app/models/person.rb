class Person < PersonsRecord
  self.primary_keys = %i[name birthdate]
  enum gender: [:female, :male]

  has_many :events, class_name: 'Event', foreign_key: %i[name birthdate]

  validates :name, :birthdate, :gender, :details, presence: true
  validate :birthdate_date_cannot_be_in_the_past

  def birthdate_date_cannot_be_in_the_past
    if birthdate.present? && birthdate > Date.today
      errors.add(:birthdate, "can't be in the future")
    end
  end
end
