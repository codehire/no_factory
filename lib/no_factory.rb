module NoFactory
  def factory(*factories)
    opts = {on_bang: :save!}
    opts = opts.merge(factories.pop) if factories.last.is_a?(Hash)

    factories.each do |factory|
      factory_module = Object.const_get("#{factory.to_s.gsub(/^./) {|s| s.upcase }}Factory")
      bang_module = Module.new do
        factory_module.instance_methods.each do |method|
          define_method "#{method}!" do |*args, &block|
            send(method, *args, &block).tap {|o| o.send(opts[:on_bang]) }
          end
        end
      end

      include bang_module
      include factory_module
    end
  end
end
