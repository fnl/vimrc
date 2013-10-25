#!/usr/bin/env ruby

git_bundles = [ 
  "git://github.com/davidhalter/jedi-vim.git",
  "git://github.com/ervandew/supertab.git",
  "git://github.com/kien/ctrlp.vim.git",
  "git://github.com/Shutnik/jshint2.vim.git",
  "git://github.com/pangloss/vim-javascript.git",
  "git://github.com/scrooloose/nerdcommenter.git",
  "git://github.com/scrooloose/nerdtree.git",
  "git://github.com/tpope/vim-fugitive.git",
  "git://github.com/tpope/vim-surround.git",
  "git://github.com/tsaleh/vim-matchit.git",
  "git://github.com/vim-scripts/taglist.vim.git",
  "git://github.com/uggedal/go-vim.git",
  "git://github.com/derekwyatt/vim-scala.git",
  "git://github.com/mattn/emmet-vim.git",
  "git://github.com/digitaltoad/vim-jade.git"
]

vim_org_scripts = [
  #["IndexedSearch", "7062",  "plugin"],
]

require 'fileutils'
require 'open-uri'

bundles_dir = File.join(File.dirname(__FILE__), "bundle")

FileUtils.cd(bundles_dir)

puts "trashing everything (lookout!)"
Dir["*"].each {|d| FileUtils.rm_rf d }

git_bundles.each do |url|
  dir = url.split('/').last.sub(/\.git$/, '')
  puts "unpacking #{url} into #{dir}"
  `git clone #{url} #{dir}`
  FileUtils.rm_rf(File.join(dir, ".git"))
end

vim_org_scripts.each do |name, script_id, script_type|
  puts "downloading #{name}"
  local_file = File.join(name, script_type, "#{name}.vim")
  FileUtils.mkdir_p(File.dirname(local_file))
  File.open(local_file, "w") do |file|
    file << open("http://www.vim.org/scripts/download_script.php?src_id=#{script_id}").read
  end
end
