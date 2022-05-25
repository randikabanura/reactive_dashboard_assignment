class Person < PersonsRecord
  include CableReady::Broadcaster

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

  after_update do
    self.reload
    cable_ready["dashboard"].morph(
      selector: "#person_#{self.uuid}",
      html: ApplicationController.render(partial: 'people/table_row', locals: {person: self })
    )
    cable_ready["dashboard"].morph(
      selector: "#person_card_#{self.uuid}",
      html: ApplicationController.render(partial: 'people/person_card', locals: {person: self })
    )
    cable_ready["dashboard"].morph(
      selector: "#person_show_#{self.uuid}",
      html: ApplicationController.render(partial: 'people/person', locals: {person: self })
    )
    cable_ready.broadcast
  end

  after_create do
    self.reload
    cable_ready["dashboard"].insert_adjacent_html(
      selector: "#people_dashboard_tbody",
      position: "afterbegin",
      html: ApplicationController.render(partial: 'people/table_row', locals: {person: self })
    )
    cable_ready["dashboard"].insert_adjacent_html(
      selector: "#people_card_container",
      position: "afterbegin",
      html: ApplicationController.render(partial: 'people/person_card', locals: {person: self })
    )
    cable_ready.broadcast
  end

  after_destroy do
    cable_ready["dashboard"].remove(
      selector: "#person_#{self.uuid}",
      )
    cable_ready["dashboard"].remove(
      selector: "#person_card_#{self.uuid}",
      )
    cable_ready.broadcast
  end
end
