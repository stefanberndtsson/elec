require 'rails_helper'

describe Item do
  it "should save when fulfilled" do
    checksum = Digest::SHA1.hexdigest("testfile\n")
    item = Item.new(name: "Item with name", checksum: checksum)
    expect(item.save).to be_truthy
  end

  it "should require name" do
    checksum = Digest::SHA1.hexdigest("testfile\n")
    item = Item.new(checksum: checksum)
    expect(item.save).to be_falsey
  end

  it "should require checksum" do
    item = Item.new(name: "Item with name")
    expect(item.save).to be_falsey
  end
  
  it "should have SHA1 checksum" do
    item = Item.new(name: "Item with name", checksum: "0101010120202020")
    expect(item.save).to be_falsey
  end

  it "should be taggable" do
    checksum = Digest::SHA1.hexdigest("testfile\n")
    item = Item.create(name: "Item with name", checksum: checksum)
    expect(item.tags.count).to eq(0)
    item.add_tag("test tag")
    expect(item.tags.count).to eq(1)
  end

  it "should not add the same tag twice" do
    checksum = Digest::SHA1.hexdigest("testfile\n")
    item = Item.create(name: "Item with name", checksum: checksum)
    expect(item.tags.count).to eq(0)
    item.add_tag("test tag")
    item.add_tag("test tag")
    expect(item.tags.count).to eq(1)
  end
  
  it "should tag without case sensitivity" do
    checksum = Digest::SHA1.hexdigest("testfile\n")
    item = Item.create(name: "Item with name", checksum: checksum)
    expect(item.tags.count).to eq(0)
    item.add_tag("test tag")
    item.add_tag("Test Tag")
    expect(item.tags.count).to eq(1)
  end
end
