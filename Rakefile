namespace :test do

  require 'rake'
  require 'spec/rake/spectask'

  desc "Run all rspec tests, including those in shared directories"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList.new File.dirname(__FILE__) + '/spec/*_spec.rb' 
  end
  
end

task :gem do
  sh 'gem build mod-auth-pubtkt-rb.gemspec'
end