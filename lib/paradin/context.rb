
module Paradin
  class Context
    if defined?(ActiveJob)
      require "active_job/arguments"
    end

    def initialize(*args, **kwargs)
      @args = serialize(args)
      @kwargs = serialize(kwargs)
    end

    def args
      deserialize(@args)
    end

    def kwargs
      deserialize(@kwargs)
    end

    private

    def serialize(obj)
      if use_active_job_serializer?
        ActiveJob::Arguments.serialize([obj])
      else
        Marshal.dump(obj)
      end
    end

    def deserialize(dump)
      if use_active_job_serializer?
        ActiveJob::Arguments.deserialize(dump).first
      else
        Marshal.load(dump)
      end
    end

    def use_active_job_serializer?
      !!defined?(ActiveJob::Arguments)
    end
  end
end
