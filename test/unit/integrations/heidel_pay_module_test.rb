require 'test_helper'

class HeidelPayModuleTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def test_notification_method
    assert_instance_of HeidelPay::Notification, HeidelPay.notification('name=cody')
  end
end
