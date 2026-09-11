# "Today" in Pacific time, for the future-date filter shared by articles
# (plugins/builders/sai_content.rb) and episodes (plugins/builders/sai_podcast.rb).
#
# The filter used to compare against the build server's UTC date, so a
# Tuesday-dated article or episode could still be a day away in Pacific time
# and already show up (Spec0027). `Time.now` on its own follows the process's
# UTC clock; setting `TZ` for the duration of the call makes libc do the
# America/Los_Angeles conversion (DST included) via the system zoneinfo
# database, with no new gem dependency. `TZ` is process-global, but this
# mutate-and-restore only ever runs synchronously on Bridgetown's single
# build thread (the `site, :post_read` hook), so there's no other thread
# that could observe the temporary value.
module Builders::PacificDate
  def self.today
    original_tz = ENV["TZ"]
    ENV["TZ"] = "America/Los_Angeles"
    Time.now.strftime("%Y-%m-%d")
  ensure
    ENV["TZ"] = original_tz
  end
end
