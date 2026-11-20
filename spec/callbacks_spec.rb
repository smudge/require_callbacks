require 'spec_helper'
require 'securerandom'

describe RequireCallbacks do
  let(:file_name) { ('a'..'z').to_a.sample(8).join }

  around(:each) do |example|
    File.open("spec/#{file_name}.rb", 'w') do |f|
      f.write("class #{file_name.upcase}; end")
    end
    begin
      example.run
    ensure
      File.delete("spec/#{file_name}.rb") if File.exist?("spec/#{file_name}.rb")
    end
  end

  it 'has a version number' do
    expect(RequireCallbacks::VERSION).not_to be nil
  end

  describe 'callback registration without a block' do
    it 'rejects after_require without changing callbacks' do
      expect { after_require(file_name) }.to raise_error(ArgumentError, 'callback block required')
      expect(RequireCallbacks::AFTER_CALLBACKS).not_to have_key(file_name)
    end

    it 'rejects before_require without changing callbacks' do
      expect { before_require(file_name) }.to raise_error(ArgumentError, 'callback block required')
      expect(RequireCallbacks::BEFORE_CALLBACKS).not_to have_key(file_name)
    end
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
  describe 'callbacks across receivers' do
    let(:loader) { Object.new }

    before do
      @before_count = 0
      @after_count = 0
      before_require(file_name) { @before_count += 1 }
      after_require(file_name) { @after_count += 1 }
    end

    it 'runs registered callbacks when a different object requires the file' do
      expect(loader.send(:require, file_name)).to eq(true)
      expect(@before_count).to eq(1)
      expect(@after_count).to eq(1)

      expect(loader.send(:require, file_name)).to eq(false)
      expect(@before_count).to eq(2)
      expect(@after_count).to eq(1)
    end
  end
end
