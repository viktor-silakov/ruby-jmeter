require 'spec_helper'

describe 'regular_expression_extractor' do
  describe 'standard scope' do
    let(:doc) do
      test do
        regex pattern: 'pattern', name: 'my_variable', match_number: 1, default: '424242'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq 'my_variable'
    end

    it 'matches on regex' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq 'pattern'
    end

    it 'matches on template' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq '$1$'
    end

    it 'matches on match_number' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.match_number']").text).to eq '1'
    end

    it 'matches on default' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.default']").text).to eq '424242'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Sample.scope']").empty?).to eq true
    end
  end

  describe 'variable scope' do
    let(:doc) do
      test do
        regex pattern: 'pattern', name: 'my_variable', variable: 'test_variable'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq 'my_variable'
    end

    it 'matches on regex' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq 'pattern'
    end

    it 'matches on template' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq '$1$'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Sample.scope']").text).to eq 'variable'
    end
  end

  describe '"Main sample only" scope' do
    let(:doc) do
      test do
        regex pattern: 'pattern', name: 'main_sample_only', scope: 'Main sample only'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq 'main_sample_only'
    end

    it 'matches on regex' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq 'pattern'
    end

    it 'matches on template' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq '$1$'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Sample.scope']").empty?).to eq true
    end
  end

  describe '"Main sample and sub-samples" scope' do
    let(:doc) do
      test do
        regex pattern: 'pattern', name: 'main_sample_and_sub', scope: 'Main sample and sub-samples'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq 'main_sample_and_sub'
    end

    it 'matches on regex' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq 'pattern'
    end

    it 'matches on template' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq '$1$'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Sample.scope']").text).to eq 'all'
    end
  end

  describe '"Sub-samples only" scope' do
    let(:doc) do
      test do
        regex pattern: 'pattern', name: 'sub_only', scope: 'Sub-samples only'
      end.to_doc
    end

    let(:fragment) { doc.search('//RegexExtractor').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.refname']").text).to eq 'sub_only'
    end

    it 'matches on regex' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.regex']").text).to eq 'pattern'
    end

    it 'matches on template' do
      expect(fragment.search(".//stringProp[@name='RegexExtractor.template']").text).to eq '$1$'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Sample.scope']").text).to eq 'children'
    end
  end

end
