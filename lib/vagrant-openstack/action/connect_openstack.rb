require "fog"
require "log4r"

module VagrantPlugins
  module OpenStack
    module Action
      # This action connects to OpenStack, verifies credentials work, and
      # puts the OpenStack connection object into the `:openstack_compute` key
      # in the environment.
      class ConnectOpenStack
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_openstack::action::connect_openstack")
        end

        def call(env)
          # Get the configs
          config   = env[:machine].provider_config
          @logger.info("Connecting to OpenStack Compute...")
          env[:openstack_compute] = Fog::Compute.new({
                        :provider => :openstack,
                        :openstack_region => config.region,
                        :openstack_username => config.username,
                        :openstack_api_key => config.api_key,
                        :openstack_auth_url => config.endpoint,
                        :openstack_tenant => config.tenant
                    })

          @app.call(env)
        end
      end
    end
  end
end
