module ThreeScaleToolbox
  class ProxyLogger < BasicObject
    def initialize(subject)
      @subject = subject
    end

    def method_missing(name, *args)
      start_time = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
      result = @subject.public_send(name, *args)
    ensure
      end_time = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC) - start_time
      ::Kernel.warn "-- call #{name} args |#{args.inspect[0..2000]}| response |#{result.inspect[0..2000]}| - (#{end_time}s)"
      result
    end

    def public_send(name, *args)
      method_missing(name, *args)
    end

    def respond_to_missing?(method_name, include_private = false)
      super
    end
  end
end
