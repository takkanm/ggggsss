RSpec.describe Ggggsss::Command do
  describe 'parse option' do
    context 'short option' do
      let(:args) {
        %w(-b any-bucket keyword aaa/bbb)
      }

      it 'works' do
        command = Ggggsss::Command.new(args)
        aggregate_failures do
          expect(command.bucket_name).to eq('any-bucket')
          expect(command.keyword).to eq('keyword')
          expect(command.path).to eq('aaa/bbb')
        end
      end
    end

    context 'long option' do
      let(:args) {
        %w(--bucket-name any-bucket keyword aaa/bbb)
      }

      it 'works' do
        command = Ggggsss::Command.new(args)
        aggregate_failures do
          expect(command.bucket_name).to eq('any-bucket')
          expect(command.keyword).to eq('keyword')
          expect(command.path).to eq('aaa/bbb')
        end
      end
    end
  end
end
