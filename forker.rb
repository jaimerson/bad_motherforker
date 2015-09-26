require 'rubygems'
require 'bundler/setup'
require 'gh'
require 'virtus'
require 'git'

class Forker
  class Repo
    include Virtus.model

    attribute :owner, Hash
    attribute :_links, Hash
  end

  attr_reader :forks

  def initialize(repo_name)
    @forks = GH["repos/#{repo_name}/forks"].map { |f| Repo.new(f) }
  end

  def fetch_or_create_repos
    forks.each(&method(:fetch_or_create_repo))
  end

  private

  def fetch_or_create_repo(repo)
    path = "repos/#{repo.owner['login']}"
    if File.exists? path
      fetch_repo(path)
    else
      create_repo(path, repo._links['clone']['href'])
    end
  end

  def create_repo(path, link)
    puts 'Cloning ' + link
    Git.clone(link, path)
  end

  def fetch_repo(path)
    puts 'Updating ' + path
    g = Git.open(path)
    g.remote('origin').fetch
    g.remote('origin').merge('master')
  end
end
