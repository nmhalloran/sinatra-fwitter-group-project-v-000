class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.string :content
      t.integer :user_id
<<<<<<< HEAD
    end
=======
>>>>>>> fccc80a9c01ad79558274cbe8ff304e7e06a26b6
  end
end
