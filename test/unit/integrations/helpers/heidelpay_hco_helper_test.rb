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

    @helper.get_redirect_url("http://example.com/")
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

    @helper.get_redirect_url("http://example.com/")
  end

  def test_currency
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("PRESENTATION.CURRENCY=EUR")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_payment_code
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("PAYMENT.CODE=CC.DB")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_response_url
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("FRONTEND.RESPONSE_URL=http://example.com/")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_amount
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("PRESENTATION.AMOUNT=5.00")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_locale
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("FRONTEND.LANGUAGE=NL")
      true
    end

    I18n.with_locale(:nl) do
      @helper.get_redirect_url("http://example.com/")
    end
  end

  def test_transaction_mode
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("TRANSACTION.MODE=INTEGRATOR_TEST")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_order_id
    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("IDENTIFICATION.TRANSACTIONID=42")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_usage
    @helper.usage = "Verwendungszweck"

    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("PRESENTATION.USAGE=Verwendungszweck")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_customer_data
    @helper.billing_address(
      :first_name => "Hanz",
      :last_name  => "Mustermann",
      :address    => "Musterstrasse 1",
      :zip        => "12345",
      :city       => "Demo City",
      :country    => "DE",
      :email      => "test@test.de")

    @helper.expects(:ssl_post).with do |url, data|
      assert data.include?("NAME.GIVEN=Hanz")
      assert data.include?("NAME.FAMILY=Mustermann")
      assert data.include?("ADDRESS.STREET=Musterstrasse 1")
      assert data.include?("ADDRESS.ZIP=12345")
      assert data.include?("ADDRESS.CITY=Demo City")
      assert data.include?("ADDRESS.COUNTRY=DE")
      assert data.include?("CONTACT.EMAIL=test@test.de")
      true
    end

    @helper.get_redirect_url("http://example.com/")
  end

  def test_successful_response
    @helper.billing_address(
      :first_name => "Hanz",
      :last_name  => "Mustermann",
      :address    => "Musterstrasse 1",
      :zip        => "12345",
      :city       => "Demo City",
      :country    => "DE",
      :email      => "test@test.de")

    @helper.usage = "Verwendungszweck"

    resp = @helper.get_redirect_url("http://example.com/")
    assert resp.include?("hcoForm.jsp")
  end

end
