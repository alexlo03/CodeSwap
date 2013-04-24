module Deprecated
# Adapted from http://www.seejohncode.com/
# NOTE: Does not work with Ruby Versions <= 1.8.7

def deprecated(name, replacement = nil)
    old_name =:"#{name}_without_deprecation"
    alias_method old_name, name
    
    define_method(name) do |*args, &block|
        if replacement
            warn "DEPRECATED ##{name} deprecated (please use ##{replacement})"
            else
            warn "DEPRECATED ##{name} deprecated"
        end
        send old_name, *args, &block
    end
end
end