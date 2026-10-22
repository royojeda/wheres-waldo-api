namespace :leaderboard do
  desc "Hide every game from the leaderboard as one restorable batch"
  task archive: :environment do
    count = Game.active.count
    archived_at = Game.archive_all
    puts "Archived #{count} games as batch #{archived_at.iso8601(6)}"
  end

  desc "List archived batches"
  task archives: :environment do
    Game.where.not(archived_at: nil).group(:archived_at).order(:archived_at).count.each do |archived_at, count|
      puts "#{archived_at.iso8601(6)}  #{count} games"
    end
  end

  desc "Return an archived batch to the leaderboard (defaults to the latest)"
  task :restore, [:batch] => :environment do |_task, args|
    archived_at = args[:batch] ? Time.zone.parse(args[:batch]) : Game.maximum(:archived_at)
    abort "No archived games to restore" unless archived_at

    puts "Restored #{Game.restore(archived_at)} games from batch #{archived_at.iso8601(6)}"
  end
end
