class PersonsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :persons, reading: :persons }
end
