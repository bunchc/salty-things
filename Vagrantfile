# -*- mode: ruby -*-
# vi: set ft=ruby :

nodes = {
    'thing'    => [1, 110],
}

Vagrant.configure("2") do |config|
    config.vm.box = "hashicorp/precise64"
    
    if Vagrant.has_plugin?("vagrant-cachier")
        config.cache.scope = :box
        config.cache.enable :apt
    else
        puts "[-] WARN: This would be much faster if you ran vagrant plugin install vagrant-cachier first"
    end

    #Default is 2200..something, but port 2200 is used by forescout NAC agent.
    config.vm.usable_port_range= 2800..2900 

    nodes.each do |prefix, (count, ip_start)|
        count.times do |i|
            #hostname = "%s-%02d" % [prefix, (i+1)]
            hostname = "%s" % [prefix, (i+1)]

            config.vm.define "#{hostname}" do |box|
                box.vm.hostname = "#{hostname}.cook.book"
                box.vm.network :private_network, ip: "172.16.0.#{ip_start+i}", :netmask => "255.255.0.0"
                box.vm.synced_folder "salt/roots/", "/srv/salt/"
                box.vm.synced_folder "salt/pillar/", "/srv/pillar/"

                # If using Fusion
                box.vm.provider :vmware_fusion do |v|
                    v.vmx["memsize"] = 1024
                end
                box.vm.provision :salt do |salt|
                    salt.minion_config = "salt/minion"
                    salt.install_type = "stable"
                    salt.always_install = true
                end
            end
        end
    end
end