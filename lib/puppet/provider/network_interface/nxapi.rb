$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","..",".."))
require 'puppet/type/cisco_interface'
require 'puppet/provider/cisco_interface/nxapi'

Puppet::Type.type(:network_interface).provide(:nxapi, :parent => Puppet::Type.type(:cisco_interface).provider(:nxapi)) do
  @doc = "cisco INTERFACE"

  has_features :activable, :describable
  #  VLAN_NON_BOOL_PROPS = [:id, :description]

  ### invoke class method to autogen the default property methods for both Puppet
  ### and the netdev module.  That's it, yo!

  mk_resource_methods
  #mk_netdev_resource_methods

  def self.instances
    interfaces = []
    Cisco::Interface.interfaces.each { |interface_name, i|
      interface = {
        :interface    => interface_name,
        :name         => interface_name,
        :description  => i.send(:description),
        :mtu          => i.send(:mtu),
        :ensure       => :present,
      }
      interfaces << new(interface)
    }
    return interfaces
        end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def flush
    if @property_flush[:ensure] == :absent
      @interface.destroy
      @interface = nil
      @property_hash[:ensure] = :absent
      else
        if @property_hash.empty?
          require 'pry'; binding.pry
          @interface = Cisco::Interface.new(@resource[:interface])
        end
        @interface.mtu = @resource[:mtu] if @resource[:mtu]
        @interface.description = @resource[:description] if @resource[:description]
        require 'pry'; binding.pry
      end
  end

end
