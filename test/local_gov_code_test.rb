# -*- coding: utf-8 -*-
require 'test_helper'

class LocalGovCodeTest < Minitest::Test
  def setup
    @local_govs = LocalGovCode.instance
  end

  def test_find
    assert_equal('帯広市', @local_govs.find(1207).name)
    assert_equal('帯広市', @local_govs.find('01207').name)
  end

  def test_that_it_has_a_version_number
    refute_nil ::LocalGovCode::VERSION
  end

  def test_create_local_gov_from_prefecture
    lg = LocalGovCode::LocalGov.new('010006','北海道','','ホッカイドウ','')
    assert_equal('01000', lg.code)
    assert_equal('北海道', lg.fullname)
    assert_equal('北海道', lg.prefname)
    assert_equal('', lg.name)
    assert_equal('ホッカイドウ', lg.prefkana)
    assert_equal('', lg.kana)
  end

  def test_create_local_gov_from_municipality
    lg = LocalGovCode::LocalGov.new('012076','北海道','帯広市','ホッカイドウ','オビヒロシ')
    assert_equal('01207', lg.code)
    assert_equal('北海道帯広市', lg.fullname)
    assert_equal('北海道', lg.prefname)
    assert_equal('帯広市', lg.name)
    assert_equal('ホッカイドウ', lg.prefkana)
    assert_equal('オビヒロシ', lg.kana)
  end

  def test_local_gov_code_creation
    assert LocalGovCode.instance
  end

  def test_local_gov_code_singleton
    a = LocalGovCode.instance
    assert @local_govs.equal?(a)  # 同一オブジェクト
  end

  def test_local_gov_code_is_unique
    data_size = @local_govs.__send__(:data).size
    assert_equal(
      data_size,
      @local_govs.instance_variable_get(:@code_hash).size
    )
  end

  def test_checksum
    @local_govs.instance_variable_get(:@code_hash).each_value do |lg|
      assert(
        lg.check_ok?,
        "#{lg.code}, #{lg.__send__(:checksum)}, #{lg.instance_variable_get(:@checksum)}"
      )
    end
  end

  def test_all
    assert_equal(@local_govs.all.size, @local_govs.__send__(:data).size)
    assert_equal('北海道', @local_govs.all[0].prefname)
    assert_equal('札幌市', @local_govs.all[1].name)
  end
end
