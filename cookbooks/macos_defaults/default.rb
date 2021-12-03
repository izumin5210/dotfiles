defaults = node[:macos_defaults]

case defaults
when Hash
  defaults_from_hash defaults
when Array
  defaults_from_hash defaults
end
