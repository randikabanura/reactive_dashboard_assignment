class Event < EventsRecord
  include CableReady::Broadcaster

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

  after_update do
    cable_ready["dashboard"].morph(
      selector: "##{self.uuid}",
      html: ApplicationController.render(partial: 'events/table_row', locals: {event: self })
    )
    cable_ready.broadcast
  end

  after_create do
    cable_ready["dashboard"].insert_adjacent_html(
      selector: "#events_dashboard_tbody",
      position: "afterbegin",
      html: ApplicationController.render(partial: 'events/table_row', locals: {event: self })
    )
    cable_ready.broadcast
  end

  after_destroy do
    cable_ready["dashboard"].remove(
      selector: "##{self.uuid}",
    )
    cable_ready.broadcast
  end
end
