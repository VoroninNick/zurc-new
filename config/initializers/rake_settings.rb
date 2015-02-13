class RakeSettings
  attr_accessor :skip_initializers

  def initialize
    @skip_initializers = !!ENV['SKIP_INITIALIZERS'] || !!ENV['si']
  end

  def skip_initializers?
    @skip_initializers
  end

  def self.rake_settings
    @rake_settings ||= RakeSettings.new
  end

  def self.self_skip_initializers?
    rake_settings.skip_initializers?
  end

end