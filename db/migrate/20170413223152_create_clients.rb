class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.string :email
      t.string :telephone
      t.string :celphone
      t.string :business_name
      t.string :commerce_name

      t.timestamps null: false
    end
  end
end
