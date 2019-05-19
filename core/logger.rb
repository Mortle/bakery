require 'logger'

module Core
  class MultiIO
    def initialize(*targets)
      @targets = targets
    end

    def write(*args)
      @targets.each { |t| t.write(*args) }
    end

    def close
      @targets.each(&:close)
    end
  end

  module Logger
    attr_reader :logger

    def initialize(*args)
      super(*args)
      log_file = (defined? config) && config[:settings] && config[:settings][:log_file]
      init_logger log_file if log_file
    end

    def init_logger(file_name)
      file = File.open(file_name, File::WRONLY | File::APPEND | File::CREAT)
      io = MultiIO.new file, STDOUT
      @logger = ::Logger.new io
    end
  end
end
