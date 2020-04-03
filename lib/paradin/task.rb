require "concurrent-ruby"

module Paradin
  module Task
    def enqueue(*args, **kwargs)
      context = Context.new(*args, **kwargs)
      context_queue.push(context)
    end

    def async
      if rails?
        raise NotSupported.new("Async task execution is not supported in Rails.")
      end

      execute!
    end

    def await
      lock_autoload_if_necessary do
        execute!.map(&:value!)
      end
    end

    private

    def execute!
      perform_method = self.class.instance_method(:perform)

      futures = context_queue.map do |context|
        create_future(context, perform_method, resolver)
      end

      context_queue.clear

      futures.each(&:touch)

      executor.shutdown
      unless executor.wait_for_termination(timeout)
        executor.kill
        raise Timeout
      end

      futures
    end

    def lock_autoload_if_necessary(&block)
      if rails?
        ActiveSupport::Dependencies.interlock.permit_concurrent_loads do
          yield
        end
      else
        yield
      end
    end

    def create_future(context, perform_method, resolver)
      Concurrent::Promises.delay_on(executor, context.clone, self.class.new, perform_method, &resolver)
    end

    def resolver
      if rails?
        lambda do |context, receiver, perform_method|
          Rails.application.executor.wrap do
            ActiveRecord::Base.connection_pool.with_connection do
              resolve(context, receiver, perform_method)
            end
          end
        end
      else
        lambda do |context, receiver, perform_method|
          resolve(context, receiver, perform_method)
        end
      end
    end

    def resolve(context, receiver, perform_method)
      if context.kwargs.size > 0
        perform_method.bind(receiver).call(*context.args, **context.kwargs)
      else
        perform_method.bind(receiver).call(*context.args)
      end
    end

    def context_queue
      @context_queue ||= Array.new
    end

    def executor
      @executor ||= Concurrent::FixedThreadPool.new(max_threads)
    end

    def rails?
      !!defined?(Rails)
    end
  end
end