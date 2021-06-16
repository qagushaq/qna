class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value
      t.references :user, foreign_key: true
      t.references :votable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end
