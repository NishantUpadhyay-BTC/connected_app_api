require 'fcm'
class NotificationService
  def self.send_notification(device_token)
    fcm_client.send([device_token], {"priority": "high", "notification": notification_json})
  end

  private

  def self.fcm_client
    FCM.new(ENV['FCM_KEY'])
  end

  def self.notification_json
    {"body": "c1", "title": "c11"}
  end
end
