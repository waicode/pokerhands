# Rails.backtrace_cleaner.add_silencer { |line| /my_noisy_library/.match?(line) }
Rails.backtrace_cleaner.remove_silencers! if ENV["BACKTRACE"]
