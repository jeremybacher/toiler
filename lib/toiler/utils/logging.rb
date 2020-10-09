require 'time'
require 'logger'

module Toiler
  module Utils
    # Initializes and exposes Toiler's default logger
    module Logging
      # Toiler's default log formatter
      class Pretty < Logger::Formatter
        def call(sev, time, progname, msg)
          formatted = msg.respond_to?(:gsub) ? msg.gsub("\n", "\n\t") : msg
          time = time.utc.iso8601
          pid = Process.pid
          if progname.to_s.empty?
            JSON.dump(timestamp: "#{time}", pid:"#{pid}", level:"#{sev}", message:"#{formatted}") + "\n"
          else
            JSON.dump(timestamp: "#{time}", pid:"#{pid}", actor:"#{progname}", level:"#{sev}", message:"#{formatted}") + "\n"
          end
        end
      end

      module_function

      def initialize_logger(log_target = STDOUT)
        log_target = STDOUT if log_target.nil?
        @logger = Logger.new(log_target)
        @logger.level = Logger::INFO
        @logger.formatter = Pretty.new
        @logger
      end

      def logger
        @logger || initialize_logger
      end

      def logger=(log)
        @logger = (log ? log : Logger.new('/dev/null'))
      end
    end
  end
end
