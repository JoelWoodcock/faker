# frozen_string_literal: true

require_relative 'test_helper'

class TestEnGbLocale < Test::Unit::TestCase
  def setup
    @previous_locale = Faker::Config.locale
    Faker::Config.locale = 'en-GB'
  end

  def teardown
    Faker::Config.locale = @previous_locale
  end

  def test_en_gb_address_methods
    assert Faker::Address.county.is_a? String
    assert Faker::Address.uk_country.is_a? String
    assert Faker::Address.default_country.is_a? String
    assert Faker::Address.country_code.is_a? String
    assert Faker::Address.postcode.is_a? String
  end

  def test_en_gb_internet_methods
    assert Faker::Internet.domain_suffix.is_a? String
  end

  def test_en_gb_phone_does_not_start_with_zero
    phone = Faker::PhoneNumber.phone_number.gsub(/\D/, '')
    refute_equal '0', phone[0]
  end

  def test_en_gb_phone_is_valid
    phone = Faker::PhoneNumber.phone_number.gsub(/\D/, '')
    assert_match(/[12358]\d{8,9}/, phone)
    refute_equal(/[04679]\d{8,9}/, phone)
  end

  def test_en_gb_cell_phone_does_not_start_with_zero
    mobile = Faker::PhoneNumber.cell_phone.gsub(/\D/, '')
    refute_equal '0', mobile[0]
  end

  def test_en_gb_cell_phone_is_valid
    mobile = Faker::PhoneNumber.cell_phone.gsub(/\D/, '')
    assert_match(/7[13456789]\d{8}/, mobile)
    # Pager numbers begin with 070 and 076xx. 07624 is used for mobiles on the Isle of Man
    refute_equal(/76(?!24)\d{8}|70\d{8}/, mobile)
  end

  def test_en_gb_postcode_has_outcode_and_incode
    postcode = Faker::Address.postcode
    assert_equal 2, postcode.split(' ').length
  end

  def test_en_gb_postcode_incode_is_valid
    # The letters C I K M O V are not used in the second part of the Postcode.
    incode = Faker::Address.postcode.split(' ')[1]
    assert_match(/\d[ABDEFGHJLNPQRSTUWXYZ]{2}/, incode)
  end

  def test_en_gb_postcode_outcode_is_valid
    outcode = Faker::Address.postcode.split(' ')[0]
    assert_includes(2..4, outcode.length)
    assert_match(/\w{1,2}\d{1,2}\w?/, outcode)
    assert_match(/^[A-PR-UWYZ][A-HK-Y0-9]/, outcode)
    assert_match(/\w{1,2}\d{1,2}|\w\d[ABCDEFGHJKPSTUW]|\w\w\d[ABEHMNPRVWXY]/, outcode)
  end
end
