class Datafile < ActiveRecord::Base
  has_many :item_datafiles
  has_many :items, :through => :item_datafiles
  belongs_to :root
  
  def self.scan_directory(path, options = {})
    default_options = {
      recurse: true,
      root: nil
    }
    files = []
    options = default_options.merge(options)
    options[:root] ||= path
    options[:root] = Pathname.new(options[:root]) if !options[:root].is_a?(Pathname)
    Pathname.new(path).children.each do |child|
      if child.directory?
        files += scan_directory(child, options) if options[:recurse]
      elsif child.file?
        tmp = add_file(child, options[:root])
        next if !tmp
        files << tmp
      end
    end
    files
  end
  
  def self.add_file(item, root)
    db_root = Root.find_or_create_by(path: root.to_s)
    relname = item.relative_path_from(root)
    filename = relname.basename.to_s
    name = relname.basename(relname.extname).to_s
    dirname = relname.dirname.to_s
    files = Datafile.where(path: dirname, filename: filename, root_id: db_root.id)
    return nil if files.count > 0

    checksum = Digest::SHA1.hexdigest(item.read)
    df = Datafile.create(filename: filename, path: dirname, root_id: db_root.id)
    items = Item.where(checksum: checksum)
    raise MultipleItemError if items.count > 1

    item = items.first
    if !item
      item = Item.create(name: name, checksum: checksum)
    end
    item.item_datafiles.create(datafile_id: df.id, item_id: item.id)
    df
  end

  def exist?
    pn = Pathname.new([root.path, path, filename].join("/"))
    pn.exist?
  end
end
