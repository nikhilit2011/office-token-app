class CreateTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :tokens do |t|
      t.string :token_number
      t.string :applicant_name
      t.string :vehicle_number
      t.string :counter
      t.string :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
