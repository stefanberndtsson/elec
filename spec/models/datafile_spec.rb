require 'rails_helper'

describe Datafile, type: :model do
  before(:each) do
    @spec_data = Rails.configuration.spec_data_path
  end
  
  it "should be able to add a file" do
    expect(Datafile.count).to eq(0)
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile.txt"), Pathname.new(@spec_data))
    expect(Datafile.count).to eq(1)
  end

  it "should not add the same file twice" do
    expect(Datafile.count).to eq(0)
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile.txt"), Pathname.new(@spec_data))
    expect(Datafile.count).to eq(1)
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile.txt"), Pathname.new(@spec_data))
    expect(Datafile.count).to eq(1)
  end

  it "should not create the same root twice" do
    expect(Root.count).to eq(0)
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile.txt"), Pathname.new(@spec_data))
    expect(Root.count).to eq(1)
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile.txt"), Pathname.new(@spec_data))
    expect(Root.count).to eq(1)
  end
  
  it "should be able to add a directory structure" do
    expect(Datafile.count).to eq(0)
    Datafile.scan_directory(@spec_data)
    expect(Datafile.count).to eq(3)
  end
  
  it "should not create multiple items for same file checksum" do
    expect(Item.count).to eq(0)
    Datafile.scan_directory(@spec_data)
    expect(Item.count).to eq(2)
  end
  
  it "should add multiple files to item when necessary" do
    expect(Item.count).to eq(0)
    Datafile.scan_directory(@spec_data)
    expect(Item.count).to eq(2)
    item = Item.find_by_checksum("fcff57d112692c8f1c3d330714358c59f1c268cc")
    expect(item.datafiles.count).to eq(2)
  end

  it "should keep item when removing redundant datafile" do
    Datafile.scan_directory(@spec_data)
    item = Item.find_by_checksum("fcff57d112692c8f1c3d330714358c59f1c268cc")
    first_datafile = item.datafiles.first
    first_datafile.remove_file
    first_id = first_datafile.id
    item = Item.find_by_checksum("fcff57d112692c8f1c3d330714358c59f1c268cc")
    expect(item.datafiles.count).to eq(1)
    expect(Item.count).to eq(2)
    expect(ItemDatafile.find_by_datafile_id(first_id)).to be nil
  end

  it "should connect checksum with tags when removing last datafile of item, but remove item" do
    Datafile.scan_directory(@spec_data)
    item = Item.find_by_checksum("d3b6569be5a62ef64049eaf940828e6bbfb38ef4")
    expect(item.datafiles.count).to eq(1)
    item.add_tag("test tag 1")
    item.add_tag("test tag 2")
    item.datafiles.first.remove_file
    item = Item.find_by_checksum("d3b6569be5a62ef64049eaf940828e6bbfb38ef4")
    expect(item).to be nil
    tag = Tag.find_by_name("test tag 1")
    expect(tag).to_not be nil
    expect(tag.item_tags.blank?).to be_falsey
    expect(tag.item_tags.first.item_id).to be nil
    expect(tag.item_tags.first.checksum).to eq("d3b6569be5a62ef64049eaf940828e6bbfb38ef4")
  end
  
  it "should reconnect tags to new item when tag-checksum match exists while adding new file" do
    Datafile.scan_directory(@spec_data)
    item = Item.find_by_checksum("d3b6569be5a62ef64049eaf940828e6bbfb38ef4")
    item.add_tag("test tag 1")
    item.add_tag("test tag 2")
    item.datafiles.first.remove_file
    Datafile.add_file(Pathname.new("#{@spec_data}/testfile2.txt"), Pathname.new(@spec_data))
    item = Item.find_by_checksum("d3b6569be5a62ef64049eaf940828e6bbfb38ef4")
    expect(item).to_not be nil
    expect(item.tags.map(&:name).include?("test tag 2")).to be_truthy
    expect(item.tags.count).to eq(2)
  end
end
