
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    
  	has_many :products
    validates :nombre, presence:true, length: { maximum: 60}, format: { with: /\A[a-zA-Z]+\z/ }
	def orders
		MyPayment.joins(:products)
			.joins("LEFT JOIN users ON products.user_id = users.id")
			.where(users:{id: self.id})

  	end
end
