module RubyJmeter
  class ExtendedDSL < DSL
    include RubyJmeter::Parser
    def response_assertion(params, &block)
      params[:scope] = params[:scope] ? scope_map[params[:scope]] : 'all'
      params[:test_type] = parse_test_type(params)
      searsh_key =  pattern_rules_filter(params).values.first
      params['0'] = searsh_key

      if params[:json]
        params[:EXPECTED_VALUE] = params[:value]
        params[:JSON_PATH] = params[:json]
        node = RubyJmeter::Plugins::JsonPathAssertion.new(params)
      end

      node ||= RubyJmeter::ResponseAssertion.new(params).tap do |node|
        if params[:variable]
          params['Scope.variable'] = params[:variable]
          node.doc.xpath("//stringProp[@name='Assertion.scope']").first.content = 'variable'

          node.doc.children.first.add_child (
            Nokogiri::XML(<<-EOS.strip_heredoc).children
              <stringProp name="Scope.variable">#{params[:variable]}</stringProp>
            EOS
          )
        end

        if searsh_key.nil? || searsh_key.empty?
          node.doc.xpath("//stringProp[@name='0']").remove
        end

        if scope_map[params[:scope]] == 'main'
          node.doc.xpath("//stringProp[@name='Assertion.scope']").remove
        end
      end

      attach_node(node, &block)
    end

    alias assert response_assertion
    alias web_reg_find response_assertion
  end
end
