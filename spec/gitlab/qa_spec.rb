require 'spec_helper'

describe Gitlab::Qa do
  it 'has a version number' do
    expect(Gitlab::Qa::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
