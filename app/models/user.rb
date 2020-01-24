class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  enum role: [0 => :admin, 1 => :tecnico_n1, 2 => :tecnico_n2, 3 =>:financeiro_n1, 4 => :financeiro_n2]
end
