# Adapted from John Crepezzi
# Visit seejohncode.com for more information
module Deprecated

# Used to denote deprecated methods with a warning. Allows for easier refactoring
def deprecated(name, replacement)
    define_method(name) do |*args, &block|
        warn "DEPRECATED ##{name} is deprecated (use ##{replacement} instead)"
        send replacement, *args, &block
    end
end
end
