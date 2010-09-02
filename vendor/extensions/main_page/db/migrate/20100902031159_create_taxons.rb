class CreateTaxons < ActiveRecord::Migration
  def self.up
    create_table :taxons do |t|
    end
  end

  def self.down
    drop_table :taxons
  end
end
