require 'cabocha'

module CaboCha
  class Token
    # 名詞？
    def noun?
      feature_list(0) == '名詞'
    end
    # 名詞接続? (「お星様」の「お」など)
    def meishi_setsuzoku?
      feature_list(0) == '接頭詞' &&
        feature_list(1) == '名詞接続'
    end
    # 動詞？
    def verb?
      feature_list(0) == '動詞'
    end
    # 形容詞？
    def adjective?
      feature_list(0) == '形容詞'
    end
    # サ変接続？ (掃除する 洗濯する など)
    def sahen_setsuzoku?
      feature_list(0) == '名詞' &&
        feature_list(1) == 'サ変接続'
    end
    # サ変する？
    def sahen_suru?
      feature_list(4) == 'サ変・スル'
    end

    # 基本形へ
    def to_base
      if (feature_list_size > 6 && feature_list(6) != "*")
        feature_list(6)
      else
        to_s
      end
    end

    def to_s
      @to_s ||=
      if ("".respond_to?("force_encoding"))
        normalized_surface.force_encoding("utf-8")
      else
        normalized_surface # 本当はsurface
      end
    end

    alias :feature_list_org :feature_list
    def feature_list(i)
      if (@feature_list)
        @feature_list[i]
      else
        if ("".respond_to?("force_encoding"))
          @feature_list ||= (0 ... feature_list_size).map do |j|
            feature = feature_list_org(j)
            feature.force_encoding("utf-8")
          end
          @feature_list[i]
        else
          @feature_list ||= (0 ... feature_list_size).map{|j| feature_list_org(j) }
          @feature_list[i]
        end
      end
    end
  end
  class Chunk
    attr_accessor :tree

    # 動詞？
    def verb?
      tokens[0].verb? || verb_sahen?
    end
    # 名詞サ変接続+スル
    def verb_sahen?
      (tokens.length > 1 &&
       tokens[0].sahen_setsuzoku? && tokens[1].sahen_suru?)
    end
    # 名詞？
    def noun?
      (!verb_sahen? && (tokens[0].noun? || tokens[0].meishi_setsuzoku?))
    end
    # 形容詞？
    def adjective?
      tokens[0].adjective?
    end
    # 主語っぽい？
    def subject?
      (((noun? && %w(は って も が).include?(tokens[-1].to_s)) ||
        (adjective? && %w(は って も が).include?(tokens[-1].to_s)) ||
        (verb? && %w(は って も が).include?(tokens[-1].to_s))))
    end
    # 基本形へ変換
    def to_base
      @to_base ||=
      if (noun?)
        # 連続する名詞、・_や名詞接続をくっつける
        base = ""
        tokens.each do |token|
          if (token.meishi_setsuzoku?)
            base += token.to_base
          elsif (token.noun?)
            base += token.to_base
          elsif (["_","・"].include?(token.to_s))
            base += token.to_base
          elsif (base.length > 0)
            break
          end
        end
        base
      elsif (verb_sahen?)
        # 名詞サ変接続 + スル
        tokens[0].to_base + tokens[1].to_base
      elsif (verb?)
        tokens[0].to_base
      elsif (adjective?)
        tokens[0].to_base
      else
        to_s
      end
    end

    def tokens
      @tokens ||= (0 ... token_size).map{|i| tree.token(token_pos + i) }
    end
    def next_chunk
      @next_chunk ||= (link >= 0) ? tree.chunk(link) : nil
    end
    def prev_chunks
      @prev_chunks ||= tree.chunks.select{|chunk| chunk.link == self_index }
    end
    def to_s
      @to_s ||= tokens.map{|t| t.to_s }.join
    end
    def self_index
      @self_index ||= tree.chunks.reduce([nil, 0]) do |argv, chunk|
        if (chunk.token_pos == self.token_pos)
          argv[0] = argv[1]
        else
          argv[1] += 1
        end
        argv
      end.shift
    end
  end
  class Tree
    alias :chunk_org :chunk
    def chunk(i)
      if (@chunks)
        @chunks[i]
      else
        chunk = chunk_org(i)
        chunk.tree = self
        chunk
      end
    end
    def chunks
      @chunks ||= (0 ... chunk_size).map {|i| chunk(i)}
    end
  end
end
