artists_names = File.new('artists').readlines.collect! { |line| line.chomp.strip }
$stdin.each { |line| puts "#{line.chomp.gsub(',',' ')} \"#{artists_names.shift}\"" }
