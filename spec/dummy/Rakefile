# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

# optimacms tasks
gem_optimacms = Gem::Specification.find_by_name 'optimacms'
Dir.glob("#{gem_optimacms.gem_dir}/tasks/**/*.rake").each { |r| load r}

#
Dir.glob('tasks/*.rake').each { |r| load r}
Dir.glob('tasks/**/*.rake').each { |r| load r}

Rake.add_rakelib 'tasks'

Rails.application.load_tasks
