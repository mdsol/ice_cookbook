require 'rubocop/rake_task'
require 'foodcritic'

desc 'RuboCop compliancy checks'
RuboCop::RakeTask.new(:rubocop)

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    tags: %w(
      ~solo
      ~FC019
    ),
    fail_tags: ['any']
  }
end

desc 'Install berkshelf cookbooks locally'
task :berkshelf do
  require 'berkshelf'
  require 'berkshelf/berksfile'
  current_dir = File.expand_path('../', __FILE__)
  berksfile_path = File.join(current_dir, 'Berksfile')
  cookbooks_path = File.join(current_dir, 'vendor')
  FileUtils.rm_rf(cookbooks_path)
  berksfile = Berkshelf::Berksfile.from_file(berksfile_path)
  berksfile.vendor(cookbooks_path)
end

task default: [:foodcritic, :rubocop]
