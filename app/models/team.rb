class Team < ApplicationRecord
  has_many :fixtures, dependent: :destroy
  has_many :players, dependent: :destroy
end
