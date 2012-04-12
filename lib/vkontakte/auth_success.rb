module VkontakteAuthentication
  
  def self.auth_success?(vk_app_password, cookie, request_mid)
    auth_data = CGI::parse(cookie)
    auth_data.update(auth_data){|key| auth_data[key][0]}
    result = "expire=%smid=%ssecret=%ssid=%s%s" % [ auth_data['expire'], auth_data['mid'], auth_data['secret'], auth_data['sid'], vk_app_password]
    Digest::MD5.hexdigest(result).to_s == auth_data['sig'].to_s and
      request_mid.to_i == auth_data['mid'].to_i
  end

  
end
