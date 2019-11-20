require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
#require 'mina/rbenv'  # for rbenv support. (https://rbenv.org)
require 'mina/rvm'    # for rvm support. (https://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :application_name, 'pola2019'
set :repository, 'https://github.com/BSorbus/pola2019.git'
#set :repository, 'git@bitbucket.org:me/myproject.git'
# git push --mirror https://bogdan.jarzab%40uke.gov.pl@bitbucket.uke.gov.pl/scm/am2019/pola2019.git
# git push --mirror https://bogdan%20jarzab@bitbucket.uke.gov.pl/scm/am2019/pola2019.git

set :branch, 'master'

task :pola2019_test do
  set :deploy_to, '/home/bogdan/www/pola2019'
  set :rails_env, 'production' 
  set :domain, '10.100.2.87'
  set :user, 'bogdan'          # Username in the server to SSH to.
  set :forward_agent, true     # SSH forward_agent.
  set :port, '22'
end

task :pola2019_prod_aaaaa do
  set :deploy_to, '/webapps/www/pola2019'
  set :rails_env, 'production' 
  set :domain, '10.100.2.188'
  set :user, 'deploy'          # Username in the server to SSH to.
  set :forward_agent, true     # SSH forward_agent.
  set :port, '22'
end


# Optional settings:
#   set :user, 'foobar'          # Username in the server to SSH to.
#   set :port, '30000'           # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# Shared dirs and files will be symlinked into the app-folder by the 'deploy:link_shared_paths' step.
# Some plugins already add folders to shared_dirs like `mina/rails` add `public/assets`, `vendor/bundle` and many more
# run `mina -d` to see all folders and files already included in `shared_dirs` and `shared_files`
# set :shared_dirs, fetch(:shared_dirs, []).push('public/assets')
# set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml')

set :shared_dirs, fetch(:shared_dirs, []).push('storage')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/storage.yml', 'config/credentials.yml.enc', 'config/master.key')


#set :rvm_use_path, '$HOME/.rvm/scripts/rvm'
set :rvm_use_path, '/usr/local/rvm/bin/rvm'
set :rvm_path,     '/usr/local/rvm/bin/rvm'

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  #invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use', 'ruby-1.9.3-p125@default'
  #command %{/bin/bash --login}
  #invoke :'rvm:use', 'ruby-2.5.3'
  # command %{gem install bundler -v 1.17.3}
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  #command %{rbenv install 2.5.3 --skip-existing}
  # command %{rvm install 2.5.3}
end

task :pre_deploy do
  run(:local) do
    command "scp config/credentials.yml.enc #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/credentials.yml.enc"
    command "scp config/master.key #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/master.key"
    command "scp config/database.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/database.yml"
    command "scp config/secrets.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/secrets.yml"
    #command "scp config/storage.yml #{fetch(:user)}@#{fetch(:domain)}:#{fetch(:shared_path)}/config/storage.yml"
  end

end

desc "Deploys the current version to the server."
task deploy: :remote_environment do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'rvm:use', 'ruby-2.5.3'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      #invoke :'rbenv:load'
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end


task :restart do
  command 'echo "-----> Restart NginX"'
  command 'sudo service nginx restart'
  #command 'echo "-----> passenger-config restart-app /webapps/www/pola2019/"'
  #command "passenger-config restart-app /home/bogdan/www/pola2019"

end

task :stop do
  command 'echo "-----> Restart NginX"'
  command 'sudo service nginx stop'
end

task :start do
  command 'echo "-----> Restart NginX"'
  command 'sudo service nginx stop'
end

task :logs do
  command "cd #{fetch(:current_path)} && sudo tail -f #{fetch(:deploy_to)}/current/log/production.log"
  command %[echo "-----> logs with command 'sudo tail -f #{fetch(:deploy_to)}/current/log/production.log'"]
end

task :seed do
  command "cd #{fetch(:current_path)} && RAILS_ENV=production bin/rails db:seed"
  command %[echo "-----> logs with command 'RAILS_ENV=production bin/rails db:seed"]
end



# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
