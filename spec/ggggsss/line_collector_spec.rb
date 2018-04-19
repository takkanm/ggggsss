require 'stringio'

RSpec.describe Ggggsss::LineCollector do
  describe '#collect!' do
    let(:body) {
      "AAABBBCCC\nBBBCCCDDD\nCCCDDDAAA\nBBAACC\nBBB"
    }
    let(:body_io) { StringIO.new(body) }
    let(:keyword) { 'BBB' }
    let(:expect_results) {
      [
        {line_no: 1, line: 'AAABBBCCC'},
        {line_no: 2, line: 'BBBCCCDDD'},
        {line_no: 5, line: 'BBB'}
      ]
    }

    it 'works' do
      collector = Ggggsss::LineCollector.new(body_io, keyword)
      collector.collect!

      expect(collector.results).to contain_exactly(*expect_results)
    end
  end
end
