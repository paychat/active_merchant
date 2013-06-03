# All right reserved.
#   (c) 2013 Paul Asmuth <paul@paulasmuth.com>

require 'test_helper'

class HeidelpayHcoHelperTest < Test::Unit::TestCase
  include ActiveMerchant::Billing::Integrations

  def setup
    @helper = HeidelpayHco::Helper.new(
      '42',                                                          # order no.
      '31ha07bc810c91f086431f7471d042d6',                            # heidelpay login
      :amount                 => 500,                                # amount in cents
      :credential2            => 'password',                         # heidelpay password
      :credential3            => '31HA07BC810C91F08643A5D477BDD7C0', # heidelpay sender
      :credential4            => '31HA07BC810C91F086433734258F6628', # heidelpay channel
      :test                   => true)

    @url = 'http://example.com'
  end

  def test_credentials
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("SECURITY.SENDER=31HA07BC810C91F08643A5D477BDD7C0")
      assert data.include?("USER.LOGIN=31ha07bc810c91f086431f7471d042d6")
      assert data.include?("USER.PWD=password")
      assert data.include?("TRANSACTION.CHANNEL=31HA07BC810C91F086433734258F6628")
      true
    end

    @helper.form_fields
  end

  def test_empty_fields
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("ACCOUNT.HOLDER=")
      assert data.include?("ACCOUNT.NUMBER=")
      assert data.include?("ACCOUNT.BRAND=")
      assert data.include?("ACCOUNT.EXPIRY_MONTH=")
      assert data.include?("ACCOUNT.EXPIRY_YEAR=")
      assert data.include?("ACCOUNT.VERIFICATION=")
      true
    end

    @helper.form_fields
  end

  def test_currency
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("PRESENTATION.CURRENCY=EUR")
      true
    end

    @helper.form_fields
  end

end
