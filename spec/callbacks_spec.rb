require 'spec_helper'
require 'securerandom'

describe RequireCallbacks do
  let(:file_name) { ('a'..'z').to_a.sample(8).join }

  around(:each) do |example|
    File.open("spec/#{file_name}.rb", 'w') do |f|
      f.write("class #{file_name.upcase}; end")
    end
    example.run
    File.delete("spec/#{file_name}.rb")
  end

  it 'has a version number' do
    expect(RequireCallbacks::VERSION).not_to be nil
  end

  describe '#require' do
    subject { require(file_name) }

    it { is_expected.to be(true) }

    context 'on second try' do
      before { require(file_name) }
      it { is_expected.to be(false) }
    end
  end

  describe '#after_require' do
    before do
      @count = 0
      after_require(file_name) { @count += 1 }
    end

    it 'should run callback' do
      expect(@count).to eq(0)
      require(file_name)
      expect(@count).to eq(1)
      require(file_name)
      expect(@count).to eq(1)
    end
  end

  describe '#before_require' do
    before do
      @count = 0
      before_require(file_name) { @count += 1 }
    end

    it 'should run callback' do
      expect(@count).to eq(0)
      require(file_name)
      expect(@count).to eq(1)
      require(file_name)
      expect(@count).to eq(2)
    end
  end
end
