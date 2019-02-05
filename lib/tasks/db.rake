# lib/tasks/db.rake
# RAILS_ENV=production rake db:dump
# RAILS_ENV=production rake db:restore
namespace :db do
  desc 'Dumps the database to db/APP_NAME.dump'
  task dump: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_dump --host #{host} --username #{user} --verbose --clean
            --no-owner --no-acl --format=c #{db} > #{Rails.root}/db/#{app}.dump"
    end
    puts cmd
    exec cmd
  end

  desc 'Restores the database dump at db/APP_NAME.dump.'
  task restore: :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} \
            --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    puts cmd
    exec cmd
  end

  desc 'Drop all database connections'
  task drop_connections: :environment do
    database = 'teaser_api_production'
    field    = if ActiveRecord::Base.connection.send(:postgresql_version) < 90_200
                 'pg_stat_activity.procpic' # PostgreSQL <= 9.1.x
               else
                 'pg_stat_activity.pid'     # PostgreSQL >= 9.2.x
               end

    begin
      ActiveRecord::Base.connection.execute <<-SQL
        SELECT pg_terminate_backend(#{field})
        FROM pg_stat_activity
        WHERE pg_stat_activity.datname = '#{database}';
      SQL
    rescue ActiveRecord::ActiveRecordError
      logger.fatal 'Connection lost to the database'
    end
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,
      ActiveRecord::Base.connection_config[:host],
      ActiveRecord::Base.connection_config[:database],
      ActiveRecord::Base.connection_config[:username]
  end
end
