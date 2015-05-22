class AddSpectralClassToStar < ActiveRecord::Migration
  def change
    add_column :stars, :spectral_class, :string
  end
end
