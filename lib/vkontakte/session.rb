module VkontakteAuthentication
  module Session
    def self.included(klass)
      klass.class_eval do
        include InstanceMethods
        validate :validate_by_vk_cookie, :if => :authenticating_with_vkontakte?
        before_destroy :destroy_vkontakte_cookies
      end
    end

    class NotInitializedError < StandardError
    end

    module InstanceMethods
      def new_registration=(value)
        @new_registration = value
      end

      def new_registration?
        @new_registration.presence
      end

      private
      def authenticating_with_vkontakte?
        record_class.vkontakte_enabled_value && controller.cookies[record_class.vk_app_cookie].present?
      end


      def validate_by_vk_cookie
        p 'AA_VK DEBUG'
        p 'params'
        p controller.params
        p 'cookies'
        p controller.cookies
        @vkontakte_data  = controller.params[:user_session] if controller.params and controller.params[:user_session]
        p 'vk_data'
        p @vkontakte_data
        if VkontakteAuthentication.auth_success?(record_class.vk_app_password,
                                                 controller.cookies[record_class.vk_app_cookie],
                                                 @vkontakte_data[:mid])
          raise(NotInitializedError, "You must define vk_id column in your User model") unless record_class.attribute_names.include?(vk_id_field.to_s)
          if @vkontakte_data
            self.attempted_record = klass.where(vk_id_field => @vkontakte_data[:mid].to_i).first
            if self.attempted_record.blank?
              # creating a new account
              self.new_registration = true
              self.attempted_record = record_class.new
              self.attempted_record.send "#{vk_id_field}=", @vkontakte_data[:mid].to_i
              self.attempted_record.send :persistence_token=, Authlogic::Random.hex_token if self.attempted_record.respond_to? :persistence_token=
              map_vkontakte_data if record_class.vkontakte_merge_enabled_value
              self.attempted_record.save_without_session_maintenance
            elsif !(record_class.vkontakte_auto_registration_value)
              self.attempted_record = record_class.new
            end
          end
          return true
        else
          errors.add(vk_id_field, "Authentication failed. Please try again.")
          return false
        end
      end

      def map_vkontakte_data
        self.attempted_record.send("#{klass.login_field}=", @vkontakte_data[:user][:nickname]) if self.attempted_record.send(klass.login_field).blank?
        self.attempted_record.send("first_name=", @vkontakte_data[:user][:first_name]) if @vkontakte_data[:user][:first_name]
        self.attempted_record.send("last_name=", @vkontakte_data[:user][:last_name]) if @vkontakte_data[:user][:last_name]
      end

      def find_by_vk_id_method
        self.class.find_by_vk_id_method
      end

      def vk_id_field
        record_class.vk_id_field
      end

      def record_class
        self.class.klass
      end

      def delete_cookie(key)
        return unless key
        domain = controller.request.domain
        [".#{domain}", "#{domain}"].each { |d| controller.cookies.delete(key, :domain => d) }
      end

      def destroy_vkontakte_cookies
        delete_cookie(record_class.vk_app_cookie)
      end
    end
  end
end
