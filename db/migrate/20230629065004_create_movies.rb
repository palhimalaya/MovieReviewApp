class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false, unique: true
      t.string :description
      t.date :release_date
      t.integer :duration
      t.string :cover_img

      t.timestamps
    end
  end
end
