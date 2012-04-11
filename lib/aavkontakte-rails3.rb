require "digest/md5"
require "vkontakte/authentication"
require "vkontakte/session"
require "vkontakte/helper"

# TODO: may be rake task..
unless File.exists?("#{Rails.root}/public/assets/vkontakte.js")
#  require "ftools"
#  File.copy("#{File.dirname(__FILE__)}/vkontakte.js", "#{Rails.root}/public/assets")
end

ActiveRecord::Base.send(:include, VkontakteAuthentication::ActsAsAuthentic)
Authlogic::Session::Base.send(:include, VkontakteAuthentication::Session)
ActionController::Base.helper VkontakteAuthentication::Helper
