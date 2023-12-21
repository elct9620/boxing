# frozen_string_literal: true

desc 'Update boxing database'
task :update do
  puts 'Updating database...'

  if Boxing::Database.exist?
    Boxing::Database.new.update!
  else
    Boxing::Database.download!
  end
end
