module RubyJmeter
  class ExtendedDSL < DSL
    include RubyJmeter::Parser
    def regular_expression_extractor(params, &block)
      params[:refname] ||= params[:name]
      params[:regex] = params[:pattern]
      params[:template] = params[:template] || "$1$"

      node = RubyJmeter::RegularExpressionExtractor.new(params).tap do |node|
        if params[:variable]
          node.doc.xpath("//stringProp[@name='Sample.scope']").first.content = 'variable'

          node.doc.children.first.add_child (
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="Scope.variable">#{params[:variable]}</stringProp>
            EOS
          )
        end

        if !scope_map[params[:scope]].nil?
          node.doc.xpath("//stringProp[@name='Sample.scope']").first.content = scope_map[params[:scope]]
        else
          node.doc.xpath("//stringProp[@name='Sample.scope']").remove if !params[:variable]
        end

        if scope_map[params[:scope]] == 'main'
          node.doc.xpath("//stringProp[@name='Sample.scope']").remove
        end
      end

      attach_node(node, &block)
    end

    alias regex regular_expression_extractor
  end
end
