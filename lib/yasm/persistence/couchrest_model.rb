module Yasm
  module Persistence
    module CouchRest
      module Model
        def self.included(base)
          base.extend GetMethods
          base.before_save :save_yasm_states
          class << base
            alias_method_chain :get, :load_yasm_states
          end
        end
        
        module GetMethods
          def get_with_load_yasm_states(id, db = database)
            doc = get_without_load_yasm_states id, db
            doc.class.state_configurations.keys.each do |state_name|
              Yasm::Manager.change_state(
                :to => doc["yasm"]["states"][state_name.to_s]["class"].to_sym.to_class,
                :on => doc.send(:state_container, state_name.to_sym), 
                :at => Time.parse(doc["yasm"]["states"][state_name.to_s]["instantiated_at"])
              )
            end if doc["yasm"] and doc["yasm"]["states"]
            doc
          end
        end
        
        private
        def save_yasm_states
          self["yasm"] ||= {}
          self["yasm"]["states"] ||= {}
          self.class.state_configurations.keys.each do |state_name|
            container = state_container state_name
            self["yasm"]["states"][state_name] = {
              :class => container.value.class.to_s,
              :instantiated_at => container.value.instantiated_at
            }
          end
        end
      end
    end
  end
end
