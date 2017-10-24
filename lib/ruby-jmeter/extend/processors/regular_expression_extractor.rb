module RubyJmeter
  class ExtendedDSL < DSL
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
      end

      attach_node(node, &block)
    end

    def scope_map
      {
          'Main sample and sub-samples' => 'all',
          'Sub-samples only' => 'children',
          'JMeter Variable' => 'variable'
      }
    end

    alias regex regular_expression_extractor
  end
end
