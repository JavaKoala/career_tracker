class HomeCalendarEvent
  include ActiveModel::Attributes
  include ActiveModel::AttributeAssignment
  include ActiveModel::Validations
  include ActiveModel::Serializers::JSON

  attribute :title, :string
  attribute :start, :datetime
  attribute :end, :datetime
  attribute :color, :string

  validates :title, presence: true
  validates :start, presence: true
  validates :end, presence: true
end
