class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
  belongs_to :manager, class_name: "Person", foreign_key: :manager_id
  has_many :employees, class_name: "Person", foreign_key: :manager_id

  def self.without_remote_manager
    joins('LEFT JOIN people managers_people ON managers_people.id = people.manager_id')
      .where('managers_people.id IS NULL OR managers_people.location_id = people.location_id')
  end

  def self.order_by_location_name
    joins(:location).order("locations.name")
  end

  def self.with_employees
    from(
      joins(:employees).distinct,
      :people
    )
  end

  def self.with_local_coworkers
    from(
      joins(location: :people).where("people_locations.id <> people.id").distinct,
      :people
    )
  end
end