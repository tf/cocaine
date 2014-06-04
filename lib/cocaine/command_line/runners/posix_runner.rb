# coding: UTF-8

module Cocaine
  class CommandLine
    class PosixRunner
      def self.available?
        require 'posix/spawn'
        true
      rescue LoadError
        false
      end

      def self.supported?
        available? && !OS.java?
      end

      def supported?
        self.class.supported?
      end

      def call(command, env = {}, options = {})
        pipe = MultiPipe.new
        pid = spawn(env, command, options.merge(pipe.pipe_options))
        pipe.read_and_then do
          waitpid(pid)
        end
        pipe.output
      end

      private

      def spawn(*args)
        POSIX::Spawn.spawn(*args)
      end

      def waitpid(pid)
        Process.waitpid(pid)
      end
    end
  end
end
