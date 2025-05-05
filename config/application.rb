module OfficeTokenBootstrapApp
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    # ✅ Set time zone to IST
    config.time_zone = "Asia/Kolkata"

    # ✅ Save DB times in local time (optional but recommended)
    config.active_record.default_timezone = :local
  end
end
