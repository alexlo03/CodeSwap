# Adapted from John Crepezzi
# Visit seejohncode.com for more information
module Deprecated

# Used to denote deprecated methods with a warning. Allows for easier refactoring
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
