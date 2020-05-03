# lib/tasks/cronjobs.rake

namespace :cronjobs do
  desc "Restart DelayedJob"
  task restart_delayed_job: :environment do
    system("#{Rails.root}/bin/delayed_job restart")
  end

  desc "Clean /tmp/zipownia"
  task clean_zipownia: :environment do
    system("rm -rf #{Rails.root}/tmp/zipownia")
  end

end