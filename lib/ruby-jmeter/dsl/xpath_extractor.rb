module RubyJmeter
  class DSL
    def xpath_extractor(params={}, &block)
      node = RubyJmeter::XpathExtractor.new(params)
      attach_node(node, &block)
    end
  end

  class XpathExtractor
    include RubyJmeter::Parser
    attr_accessor :doc
    include Helper

    def initialize(params={})
      testname = params.kind_of?(Array) ? 'XpathExtractor' : (params[:name] || 'XpathExtractor')
      @doc = Nokogiri::XML(<<-EOS.strip_heredoc)
<XPathExtractor guiclass="XPathExtractorGui" testclass="XPathExtractor" testname="#{testname}" enabled="true">
  <stringProp name="XPathExtractor.default"/>
  <stringProp name="XPathExtractor.refname"/>
  <stringProp name="XPathExtractor.xpathQuery"/>
  <boolProp name="XPathExtractor.validate">false</boolProp>
  <boolProp name="XPathExtractor.tolerant">true</boolProp>
  <boolProp name="XPathExtractor.namespace">false</boolProp>
  <stringProp name="XPathExtractor.matchNumber">1</boolProp>
  <stringProp name="Sample.scope">all</stringProp>
</XPathExtractor>)
      EOS
      @doc.xpath("//stringProp[@name='Sample.scope']").first.content = scope_map[params[:scope]] if !scope_map[params[:scope]].nil?
      @doc.xpath("//stringProp[@name='Sample.scope']").remove if scope_map[params[:scope]] == 'main'
      @doc.xpath("//stringProp[@name='XPathExtractor.matchNumber']").first.content = params[:match_number].to_s if params[:match_number]
      update params
      update_at_xpath params if params.is_a?(Hash) && params[:update_at_xpath]
    end
  end
end
