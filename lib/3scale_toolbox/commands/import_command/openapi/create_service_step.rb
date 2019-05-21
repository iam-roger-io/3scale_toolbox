module ThreeScaleToolbox
  module Commands
    module ImportCommand
      module OpenAPI
        class CreateServiceStep
          include Step

          ##
          # Creates service with a given system_name
          # If service already exists, update basic settings like name and description
          def call
            # Update service and update context
            self.service = Entities::Service.find_by_system_name(remote: threescale_client,
                                                                 system_name: service_system_name)
            if service.nil?
              # Create service and update context
              self.service = Entities::Service.create(remote: threescale_client,
                                                      service_params: service_settings)
              puts "Created service id: #{service.id}, name: #{service_name}"
            else
              service.update(service_settings)
              puts "Updated service id: #{service.id}, name: #{service_name}"
            end
          end

          private

          def service_system_name
            target_system_name || service_name.downcase.gsub(/[^\w]/, '_')
          end

          def service_settings
            default_service_settings.tap do |svc|
              svc['name'] = service_name
              svc['description'] = service_description
              svc['backend_version'] = backend_version
              svc['system_name'] = service_system_name
            end
          end

          def default_service_settings
            {}
          end

          def service_name
            api_spec.title
          end

          def service_description
            api_spec.description
          end

          def backend_version
            api_spec.backend_version
          end
        end
      end
    end
  end
end
