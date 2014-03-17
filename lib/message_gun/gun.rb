require 'yaml'
require 'twilio-ruby'
require 'faker'

module MessageGun
  class Gun

    def initialize(args)
      @input_file = args.fetch(:input_file)

      trap(:INT) { exit! }
    end

    def run
      @config = YAML::load(File.open(@input_file))
      @client = Twilio::REST::Client.new(
        @config['twilio_sid'],
        @config['twilio_auth_token']
      )

      child_pids = @config['senders'].each_with_object([]) do |sender, pids|
        pids << spawn_child(sender)
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
        exit!

        child_pids.delete(pid)
        child_pids << spawn_child
      end
    end

    private

    def spawn_child(sender)
      fork do
        loop do
          text = Faker::Lorem.sentence
          puts "Process #{Process.pid} sending: #{text}"
          @client.account.messages.create(
            :from => sender,
            :to => @config['receiver'],
            :body => text
          )
          sleep(rand(10..60))
        end
      end
    end
  end
end
