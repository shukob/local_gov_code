# -*- coding: utf-8 -*-

require 'singleton'
require "local_gov_code/version"
require "local_gov_code/local_gov_data"

class LocalGovCode
  include Singleton

  def initialize
    @code_hash     = {}
    @fullname_hash = {}
    @name_hash     = {}

    data.each do |lg|
      local_gov = LocalGov.new(*lg)
      @code_hash[local_gov.code.to_i]     = local_gov

      @fullname_hash[local_gov.name] = [] if @fullname_hash[local_gov.name].nil?
      @fullname_hash[local_gov.name] << local_gov

      @name_hash[local_gov.name] = [] if @name_hash[local_gov.name].nil?
      @name_hash[local_gov.name] << local_gov
    end

    @code_hash.freeze
    @fullname_hash.freeze
    @name_hash.freeze
  end

  # 5桁の地方公共団体コードに該当するLocalGovオブジェクトを返す
  # コードは文字列でも整数でも可。
  # 例）北海道 '01000' or 1000
  def find(code)
    @code_hash[code.to_i]
  end

  # 都道府県＋市区町村名で検索
  def find_by_fullname(fullname)
    @fullname_hash[fullname]
  end

  # 市区町村名で検索
  def find_by_name(name)
    @name_hash[name]
  end

  # すべてのLocalGovの配列を返す。順番は地方自治体コード順。
  def all
    @code_hash.sort.collect { |lg| lg.last }
  end

  #--------------------------------------------------------------------

  #
  # 各地方公共団体を扱うクラス
  #
  class LocalGov
    attr_reader :prefname, :name, :prefkana, :kana

    def initialize(code, prefname, name, prefkana, kana)
      @code     = code.to_i / 10 # ６桁目チェックコードは除く
      @checksum = code.to_i % 10
      @prefname = prefname
      @name     = name
      @prefkana = prefkana
      @kana     = kana
    end

    def code
      sprintf("%05d", @code)
    end

    def fullname
      "#{prefname}#{name}"
    end

    # テスト用
    def check_ok?
      @checksum == checksum
    end

    private

    # 全国地方公共団体コード仕様（平成19年4月1日総務省）
    # １１．検査数字
    # 全国地方公共団体コードにおける検査数字は、電算処理にあたって、不
    # 正なコードが使われないよう第6桁目をチェック用としたもので、次の方
    # 式により算出した数字とする。 (方式)第1桁から第5桁までの数字に、そ
    # れぞれ6.5.4.3.2を乗じて算出した積の和を求め、その和を11で除し、商
    # と剰余(以下「余り数字」という。)を求めて、11と余り数字との差の下
    # 1桁の数字を検査数字とする。 ただし、積の和が11より小なるときは、
    # 検査数字は、11から積の和を控除した数字とする。
    #
    def checksum
      c = @code
      c, n5 = c.divmod(10)
      c, n4 = c.divmod(10)
      c, n3 = c.divmod(10)
      c, n2 = c.divmod(10)
      c, n1 = c.divmod(10)

      sum = n1*6 + n2*5 + n3*4 + n4*3 + n5*2
      if sum < 11
        11 - sum
      else
        q =sum.modulo(11)
        (11 - q).modulo(10)
      end
    end
  end
end
