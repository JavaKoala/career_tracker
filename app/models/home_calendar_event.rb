class HomeCalendarEvent
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attribute :id, :integer
  attribute :title, :string
  attribute :start, :datetime
  attribute :end, :datetime
  attribute :color, :string
  attribute :recurring_uuid, :string

  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true
end
