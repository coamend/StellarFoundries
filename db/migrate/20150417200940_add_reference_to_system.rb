class AddReferenceToSystem < ActiveRecord::Migration
  def change
    add_reference :systems, :parent_system, index: true
  end
end
