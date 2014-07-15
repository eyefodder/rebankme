class AddAddressDteailsToBranch < ActiveRecord::Migration
  def change
    add_column :branches, :street, :string
    add_column :branches, :city, :string
    add_column :branches, :state, :string
    add_column :branches, :zipcode, :string
    add_column :branches, :latitude, :float
    add_column :branches, :longitude, :float
  end
end
