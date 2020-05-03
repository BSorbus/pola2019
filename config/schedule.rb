# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

env :PATH, ENV['PATH']
set :bundle_command, "/home/deploy/.rbenv/shims/bundle exec"


set :environment, :production
set :output, "#{Rails.root}/log/cron_log.log"


every '40 10 * * 1' do
  rake 'cronjobs:clean_zipownia'
end

# every '30 9 * * 1-6' do
#   rake 'cronjobs:clean_zipownia'
# end

every '30 4 * * *' do
  rake 'cronjobs:restart_delayed_job'
end

every :reboot do
 rake 'cronjobs:restart_delayed_job'
end
