class ChangeDefaultRole < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :role, from: 'Audience', to: 'audience'
  end
end
