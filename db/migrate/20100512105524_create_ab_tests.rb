class CreateAbTests < ActiveRecord::Migration
  def self.up
    create_table :ab_tests do |t|
      t.string  :name
      t.text    :description
      t.integer :metric_id


      t.timestamps
    end
  end

  def self.down
    drop_table :ab_tests
  end
end
