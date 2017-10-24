require 'spec_helper'
require 'pp'

describe 'response assertion' do
  describe 'standard scope' do
    let(:doc) do
      test do
        assert name: 'standard scope name', contains: 'We test, tune and secure your site'
      end.to_doc
    end

    let(:fragment) { doc.search('//ResponseAssertion').first }

    it 'matches of name' do
      expect(fragment.attributes['testname'].value).to eq 'standard scope name'
    end

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='0']").text).to eq 'We test, tune and secure your site'
    end

    it 'matches on test_type' do
      expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq '2'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq 'all'
    end
  end

  describe 'custom scope' do
    let(:doc) do
      test do
        assert name: 'custom scope name', 'not-contains' => 'Something in frames', scope: 'children'
      end.to_doc
    end

    let(:fragment) { doc.search('//ResponseAssertion').first }

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='0']").text).to eq 'Something in frames'
    end

    it 'matches on test_type' do
      expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq '6'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq 'children'
    end
  end

  describe 'variable scope' do
    let(:doc) do
      test do
        assert name: 'name variable scope', 'substring' => 'Something in frames', scope: 'children', variable: 'test'
      end.to_doc
    end

    let(:fragment) { doc.search('//ResponseAssertion').first }

    it 'matches of name' do
      expect(fragment.attributes['testname'].value).to eq 'name variable scope'
    end

    it 'matches on refname' do
      expect(fragment.search(".//stringProp[@name='0']").text).to eq 'Something in frames'
    end

    it 'matches on test_type' do
      expect(fragment.search(".//intProp[@name='Assertion.test_type']").text).to eq '16'
    end

    it 'matches on scope' do
      expect(fragment.search(".//stringProp[@name='Assertion.scope']").text).to eq 'variable'
    end
  end
end
