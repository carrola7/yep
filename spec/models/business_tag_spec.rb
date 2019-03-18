require 'rails_helper'

describe BusinessTag do
  it { should belong_to :business }
  it { should belong_to :tag }
end