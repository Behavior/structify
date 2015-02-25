module Structify
  class Parser
    attr_reader :tree, :nodes

    def initialize
      @parser = CaboCha::Parser.new
      @nodes = {}
    end

    def parse(sentence)
      @tree = @parser.parse(sentence)
      @tree.chunks.each do |chunk|
        if (chunk.next_chunk && chunk.noun?)
          left, right = chunk, chunk.next_chunk
          particle = chunk.tokens.size > 1 ? chunk.tokens.last : 'が'
          if particle.to_s =~ /[が]/
            base, context = left, right
          else
            base, context = right, left
          end

          particle_tbl = {
            "の" => "%{base}.%{context}",
            "が" => "Exec(%{base}.receive) == %{context}",
            "に" => "Scheduler.new(%{context}){ %{base} }", # leftが形容動詞の場合は別
            "を" => "%{base}(%{context})"
          }
          aliases = {
            "流す" => "activate",
            "止める" => "deactivate",
            "音楽" => Controllers::Music,
            "明日" => "Timeslot::Tomorrow"
          }

          puts particle_tbl[particle.to_s] % {base: ba, context: ca}

          @nodes[ba] ||= []
          if @nodes[ba].include? ca.to_s
            @nodes[ba] << ca.new(@nodes[ba].to_s)
          else
            @nodes[ba] << ca.new
          end
        end
      end

      pp @nodes

      @nodes.has_key?('activate') && @nodes['activate'].each do |node|
        # puts "#{node} will be active"
        # puts node.new
      end
    end
  end
end
