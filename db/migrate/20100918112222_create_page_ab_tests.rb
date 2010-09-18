class CreatePageAbTests < ActiveRecord::Migration
  def self.up
    add_column :pages, :ab_test_id, :integer
  end

  def self.down
    remove_column :pages, :ab_test_id
  end
end
