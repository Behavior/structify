require 'spec_helper'

describe Structify::Parser do
  it 'test' do
    sentences = [
      "玄関のランプを消して",
      "適当に音楽を再生",
      "アラームを止めて窓を開けて",
      "次の日曜日の朝に雨が降る予報が出たら、花見の参加者に中止の連絡を入れておいて。あと明日の発表会は大事なイベントだから間に合うように目覚ましをセットしておいて。もし間に合わなかったらタクシーを家の前に呼んでおいて。"
    ]

    # 原則
    # * プラグインはストリーム形式
    # * 類推不可能なほどコンテキストが不足する場合は追加質問をする

    # 例
    # "明日の気温が低かったら起床前に暖房を付けて"
    # -- 明日 => 気温
    # -- 気温 => 低い
    # -- 起床前 => 付ける
    # -- 暖房 => 付ける
    # 終端ノードから解析
    # 1. "付ける[behavior:active]" => "暖房[controller:aircon]"
    #                             => ("前[condition:before]" => "起床[timeslot:morning]")
    # result.
    # activate(Aircon) if Time.now < Timeslot::Morning.begin
    #
    # 2. "低い[condition:low]" => "気温[fetcher:temperature]"
    #    "気温[fetcher:temperature]" => "明日[timeslot:tomorrow]"

    sentences.each do |sentence|
      puts "\n##{sentence}"
      parser = Structify::Parser.new
      parser.parse(sentence)
    end
  end
end
