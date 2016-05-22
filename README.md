# LocalGovCode

全国地方公共団体コード（都道府県コード及び市区町村コード）を収録したgem。

データソースは[総務省HP](http://www.soumu.go.jp/denshijiti/code.html)（平成28年5月21日閲覧）。

* 都道府県コード及び市区町村コードは平成26年4月5日現在のもの。

## Installation

Gemfileに次の1行を加え、

gem 'local_gov_code'

その後、bundleでインストール。

    $ bundle

あるいは、

    $ gem install local_gov_code

## Usage

LocalGovCodeのインスタンスに対して地方自治体コード（５桁）で問い合わせる（findメソッド）ことで、LocalGovインスタンスが得られます。

また、都道府県名＋市区町村名や市区町村名で問い合わせる（find_by_fullname, find_by_nameメソッド）と、LocalGovインスタンスの配列が得られます。

LocalGovインスタンスからは、市区町村コード、都道府県名、市区町村名、よみなどを取得することが出来ます。

    require 'local_gov_code'

    # new ではなく、 instance メソッドを用います。
    local_gov_code = LocalGovCode.instance

    # 地方自治体コード（５桁）でLocalGovインスタンスを取得

    lg01000 = local_gov_code.find(1000)   # 整数でも可。これは北海道'01000'
    lg47201 = local_gov_code.find('47201') # 文字列でも可

    # LocalGovインスタンスは、次の情報を持っている。

    lg01000.code      # '01000'
    lg01000.checksum  # 0
    lg01000.fullname  # '北海道'
    lg01000.prefname  # '北海道'
    lg01000.name      # ''
    lg01000.prefkana  # 'ホッカイドウ'
    lg01000.kana      # ''

    lg47201.code      # '47201'
    lg47201.checksum  # 8
    lg47201.fullname  # '沖縄県那覇市'
    lg47201.prefname  # '沖縄県'
    lg47201.name      # '那覇市'
    lg47201.prefkana  # 'オキナワケン'
    lg47201.kana      # 'ナハシ'

    # 都道府県名＋市区町村名だと配列が得られます。
    # 現在は同一都道府県に同一名称の市区町村は複数ありませんので、
    # 配列の要素数はすべて１です。

    tokyokitaku = local_gov_code.find_by_fullname('東京都北区').first
    tokyokitaku.code  # '13117'

    # 市区町村名だけでも配列が得られます。

    ikedas = local_gov_code.find_by_name('池田町')
    ikedas.each do |ikeda|
      print ikeda.fullname
      print ' '
    end
    # -> 北海道池田町 福井県池田町 長野県池田町 岐阜県池田町

    # 政令市は、政令市名のほか政令市＋区名でもデータがあります。
    # 例えば、３区ある静岡市の場合は、次の４つのデータが存在します。
    # '22100' 静岡市
    # '22101' 静岡市葵区
    # '22102' 静岡市駿河区
    # '22103' 静岡市清水区

    # find_by_fullname, find_by_nameは `==` のものを検索します。

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cxn03651/local_gov_code.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
