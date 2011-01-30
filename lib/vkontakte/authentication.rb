module VkontakteAuthentication
  module ActsAsAuthentic
    def self.included(klass)
      klass.class_eval do
        extend Configuration, Config
        if defined? AuthlogicRpx
          remove_acts_as_authentic_module AuthlogicRpx::ActsAsAuthentic::Methods
          add_acts_as_authentic_module Methods, :prepend
          add_acts_as_authentic_module AuthlogicRpx::ActsAsAuthentic::Methods
        else
          add_acts_as_authentic_module Methods, :prepend
        end
      end
    end

    module Config
      def vkontakte_enabled(vk_app_data = {})
        value = true if vk_app_data.present? && vk_app_data[:vk_app_id] && vk_app_data[:vk_app_password]
        if vkontakte_enabled_value(value)
          vk_app_id vk_app_data[:vk_app_id]
          vk_app_password vk_app_data[:vk_app_password]
        end
      end
      alias_method :vkontakte_enabled=, :vkontakte_enabled
    end

    module Methods
      def self.included(klass)
        klass.class_eval do
          validates_length_of_password_field_options validates_length_of_password_field_options.merge(:if => :validate_password_not_vkontakte?)
          validates_confirmation_of_password_field_options validates_confirmation_of_password_field_options.merge(:if => :validate_password_not_vkontakte?)
          validates_length_of_password_confirmation_field_options validates_length_of_password_confirmation_field_options.merge(:if => :validate_password_not_vkontakte?)
        end
      end

      private
      def validate_password_not_vkontakte?
        !authenticating_with_vkontakte? && (defined?(AuthlogicRpx) ? !using_rpx? : true) && require_password?
      end

      def authenticating_with_vkontakte?
        vk_id.present? 
      end
    end
  end
end
