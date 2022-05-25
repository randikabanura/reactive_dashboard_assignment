class Event < EventsRecord
  self.primary_keys = %i[name birthdate]
  enum event_type: [:urgent, :normal, :minor]

  belongs_to :person, foreign_key: %i[name birthdate], optional: true

  validates :name, :birthdate, :description, :event_type, presence: true
  validate :birthdate_date_cannot_be_in_the_past

  def birthdate_date_cannot_be_in_the_past
    if birthdate.present? && birthdate > Date.today
      errors.add(:birthdate, "can't be in the future")
    end
  end
end
