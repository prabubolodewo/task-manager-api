class GroupInvitation < ApplicationRecord
    before_create  :set_uuid  
    def set_uuid
        self.id  = SecureRandom.uuid  
    end 

    database relation 
    belongs_to :group, optional: true 
    belongs_to :sender, :class_name => 'User', optional: true  
    belongs_to :recipient, :class_name => 'User', optional: true 

    before_create :generate_token 
    before_save :check_user_existance  

    private  

    def generate_token
        self.token = Digest::SHA1.hexdigest([self.group_id, Time.now, rand].join) 
    end

    def check_user_existance
        existing_user = User.find_by_email(recipient_id)
        if existing_user
            errors.add :recipient_email, 'is already a member'
        else  
            recipient_id
        end
    end 
end
