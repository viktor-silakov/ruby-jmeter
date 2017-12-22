require 'spec_helper'

describe 'xpath extract' do
  let(:doc) do
    test do
      extract xpath: '//node', name: 'my_xpath'
    end.to_doc
  end

  let(:fragment) { doc.search('//XPathExtractor').first }

  it 'should match on refname' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.refname']").text).to eq 'my_xpath'
  end
end


describe '"Main sample only" scope' do
  let(:doc) do
    test do
      extract xpath: '//xpath_main_sample_scope', name: 'xpath_main_sample_scope', scope: 'Main sample only'
    end.to_doc
  end

  let(:fragment) { doc.search('//XPathExtractor').first }

  it 'should match on refname' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.refname']").text).to eq 'xpath_main_sample_scope'
  end

  it 'should match on xpathQuery' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.xpathQuery']").text).to eq '//xpath_main_sample_scope'
  end

  it 'matches on scope' do
    expect(fragment.search(".//stringProp[@name='Sample.scope']").empty?).to eq true
  end
end

describe 'Match number' do
  let(:doc) do
    test do
      extract xpath: '//xpath_match_number', name: 'xpath_match_number', scope: 'Main sample only', match_number: 123
    end.to_doc
  end

  let(:fragment) { doc.search('//XPathExtractor').first }

  it 'should match on refname' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.refname']").text).to eq 'xpath_match_number'
  end

  it 'should match on xpathQuery' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.xpathQuery']").text).to eq '//xpath_match_number'
  end

  it 'matches on scope' do
    expect(fragment.search(".//stringProp[@name='Sample.scope']").empty?).to eq true
    end

  it 'matches on match number' do
    expect(fragment.search(".//stringProp[@name='XPathExtractor.matchNumber']").text).to eq '123'
  end
end
