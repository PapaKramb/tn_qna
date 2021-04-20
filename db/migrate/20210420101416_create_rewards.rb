class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :title
      t.text :image_url
      t.belongs_to :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
