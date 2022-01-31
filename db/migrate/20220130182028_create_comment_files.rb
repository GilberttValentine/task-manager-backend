class CreateCommentFiles < ActiveRecord::Migration[7.0]
  def change
    create_table :comment_files do |t|
      t.string :url
      t.references :comment, null: false, foreign_key: true

      t.timestamps
    end
  end
end
