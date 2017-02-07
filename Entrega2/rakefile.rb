rule '.rb' => '.y' do |t|
  sh "racc -v -o #{t.name} #{t.source}"
end

task :compile => 'parser.rb'
task :test => :compile