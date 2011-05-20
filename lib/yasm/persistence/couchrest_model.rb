module Yasm
  module Persistence
    module CouchRest
      module Model
        def self.included(base)
          base.extend GetMethods
          base.before_save :save_yasm_states
          class << base
            alias_method_chain :create_from_database, :load_yasm_states
          end
        end
        
        module GetMethods
          def create_from_database_with_load_yasm_states(doc = {})
            result = create_from_database_without_load_yasm_states doc
            setup_document_state result
          end
          
          private
          def setup_document_state(doc)
            doc.class.state_configurations.keys.each do |state_name|
              Yasm::Manager.change_state(
                :to => doc["yasm"]["states"][state_name.to_s]["class"].to_sym.to_class,
                :on => doc.send(:state_container, state_name.to_sym), 
                :at => Time.parse(doc["yasm"]["states"][state_name.to_s]["instantiated_at"])
              )
            end if doc and doc["yasm"] and doc["yasm"]["states"]
            doc.fast_forward if doc
            doc
          end
        end
        
        private
        def save_yasm_states
          self["yasm"] ||= {}
          self["yasm"]["states"] ||= {}
          self.class.state_configurations.keys.each do |state_name|
            container = state_container state_name
            self["yasm"]["states"][state_name.to_s] = {
              :class => container.value.class.to_s,
              :instantiated_at => container.value.instantiated_at
            }
          end
        end
      end
    end
  end
end
