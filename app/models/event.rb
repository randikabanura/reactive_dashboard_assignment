class Event < EventsRecord
  include CableReady::Broadcaster

  self.primary_keys = %i[name birthdate uuid]
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
    self.reload
    cable_ready["dashboard"].morph(
      selector: "#event_#{self.uuid}",
      html: ApplicationController.render(partial: 'events/table_row', locals: {event: self })
    )
    cable_ready["dashboard"].morph(
      selector: "#event_card_#{self.uuid}",
      html: ApplicationController.render(partial: 'events/event_card', locals: {event: self })
    )
    cable_ready["dashboard"].morph(
      selector: "#event_show_#{self.uuid}",
      html: ApplicationController.render(partial: 'events/event', locals: {event: self })
    )
    if self.person.present?
      cable_ready["dashboard"].morph(
        selector: "#event_card_#{self.uuid}_with_person_#{self.person.uuid}",
        html: ApplicationController.render(partial: 'events/event_card', locals: { event: self, person: self.person })
      )
    end
    cable_ready.broadcast
  end

  after_create do
    self.reload
    cable_ready["dashboard"].insert_adjacent_html(
      selector: "#events_dashboard_tbody",
      position: "afterbegin",
      html: ApplicationController.render(partial: 'events/table_row', locals: {event: self })
    )
    cable_ready["dashboard"].insert_adjacent_html(
      selector: "#events_card_container",
      position: "afterbegin",
      html: ApplicationController.render(partial: 'events/event_card', locals: {event: self })
    )
    if self.person.present?
      cable_ready["dashboard"].insert_adjacent_html(
        selector: "#events_related_to_person_#{self.person.uuid}",
        position: "afterbegin",
        html: ApplicationController.render(partial: 'events/event_card', locals: { event: self, person: self.person })
      )
    end
    cable_ready.broadcast
  end

  after_destroy do
    cable_ready["dashboard"].remove(
      selector: "#event_#{self.uuid}",
    )
    cable_ready["dashboard"].remove(
      selector: "#event_card_#{self.uuid}",
      )
    cable_ready["dashboard"].remove(
      selector: "#event_card_#{self.uuid}_with_person_#{self.person.uuid}",
      )
    cable_ready.broadcast
  end
end
