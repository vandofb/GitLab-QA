require 'open3'

module Docker
  class Base
    def self.act(*args, &block)
      new.tap do |page|
        return page.instance_exec(*args, &block)
      end
    end

    private

    def exec(cmd)
      # Open3.popen2(cmd) do |in, out, wait|
      #   out.each { |line| puts line }
      #
      #   exit_status = wait.value
      # end
    end
  end
end
