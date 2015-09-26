require_relative 'forker'

namespace :forks do
  task :clone, :repo_name do |t, args|
    repo_name = args[:repo_name]
    Forker.new(repo_name).fetch_or_create_repos
  end

  task :clean do
    %x{rm ./repos/* -rf}
  end
end


