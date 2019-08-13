class Student < Person
end

class Coach < Person
end

class AddTypeToMemberships < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :type, :string
    Membership.all.each do |membership|
      membership.type = "#{membership.person.type}Membership"
      membership.save!
    end
  end
end
