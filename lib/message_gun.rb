require "message_gun/version"

module MessageGun

  class Gun
    CONCURRENCY = 4

    def initialize()
      trap(:INT) { exit! }
    end

    def run
      child_pids = []

      CONCURRENCY.times do
        child_pids << spawn_child
      end

      trap(:INT) {
        child_pids.each do |cpid|
          begin
            Process.kill(:INT, cpid)
          rescue Errno::ESRCH
            puts "ERROR: Can't kill process"
          end
        end

        exit
      }

      loop do
        pid = Process.wait
        $stderr.puts "Process #{pid} quit unexpectedly"

        child_pids.delete(pid)
        child_pids << spawn_child
      end
    end

    def spawn_child
      fork do
        loop do
          puts "Hello World: #{Process.pid}"
          sleep(rand(1..6))
        end
      end
    end
  end
end

process = MessageGun::Gun.new()
process.run