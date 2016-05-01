class CreateConvos < ActiveRecord::Migration
  def change
    create_table :convos do |t|
      t.text :text

      t.timestamps null: false
    end
  end
end
