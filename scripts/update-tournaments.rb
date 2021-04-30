require 'git'

repo = Git.open(Pathname("#{__dir__}/.."))

log = repo.log.between(repo.log.first)
puts log
