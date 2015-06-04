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

          # if base.tokens.first.feature_list(0) == "動詞"
          #   puts "Do #{base.to_base} for #{context.to_base}"
          # else
          #   puts "Apply context '#{context.to_base}' for #{base.to_base}"
          # end

          particle_tbl = {
            "の" => "Apply context %{context} for %{base}",
            "が" => "%{base} == %{context}",
            "に" => "Do %{base} when %{context}", # leftが形容動詞の場合は別
            "を" => "Do %{base} for %{context}"
          }

          puts particle_tbl[particle.to_s] % {base: base.to_base, context: context.to_base}

          @nodes[base.to_base] ||= []
          if @nodes[base.to_base].include? context.to_base.to_s
            @nodes[base.to_base] << context.to_base.to_s(@nodes[base.to_base].to_s)
          else
            @nodes[base.to_base] << context.to_base.to_s
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
