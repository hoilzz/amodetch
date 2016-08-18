class User < ActiveRecord::Base
   # scope :count_of_timetable, -> { joins(:timetables).select() }

	 has_many :valuations, dependent: :destroy

   has_many :timetables, dependent: :destroy

   validates :nickname, presence: true, :length => { :minimum => 1, :maximum => 10 }, :uniqueness => true, :allow_nil => true

   validates :email, presence: true, length: {maximum: 155},
                    uniqueness: true
   validates :password, presence: true, length: { minimum: 6 }
   has_secure_password


  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid      = auth.uid
      user.name     = auth.info.name
      user.token    = auth.token
      user.email 		= auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.save
    end
  end

  def evaluated_valuation(lec,t,c)
    valuations.create(lecture_id: lec.id,total: t, content: c)
  end

	def has_not_valuation? (lecture_id)
		valuation = self.valuations.find_by(lecture_id: lecture_id)
		return valuation.nil?
	end

end
