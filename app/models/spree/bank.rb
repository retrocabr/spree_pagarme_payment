# coding: utf-8
module Spree
  class Bank < Spree::Base
    self.table_name = "spree_banks"

    validates :code, uniqueness: true

    default_scope { order('name ASC') }
    scope :is_bookmarked, -> { where(bookmarked: true) }

    self.whitelisted_ransackable_attributes = %w[name code bookmarked]

  end
end