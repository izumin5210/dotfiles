def type_from_value value
  case value
  when String      then 'string'
  # when ???       then 'data'
  when Integer     then 'int'
  when Float       then 'float'
  when TrueClass   then 'bool'
  when FalseClass  then 'bool'
  # when ???       then 'date'
  when Array       then 'array'
  # when ???       then 'array-add'
  # when ???       then 'dict'
  # when ???       then 'dict-add'
  else
    fail "Unexpected type: #{value} (#{value.class})"
  end
end

def execute_macos_defaults(defaults, domain = 'NSGlobalDomain')
  key = defaults[:key]
  value = defaults[:value]
  type = defaults[:type] || type_from_value(value)
  execute "defaults write #{domain} #{key} -#{type} #{value}" do
    not_if "defaults read #{domain} #{key} | grep -q -E '^#{value}$'"
  end
end

def from_hash defaults_by_domain
  defaults_by_domain.each do |domain, defaults_list|
    defaults_list.each do |defaults|
      execute_macos_defaults(defaults, domain)
    end
  end
end

def from_array defaults_list
  defaults_list.each do |defaults|
    execute_macos_defaults(defaults)
  end
end

defaults = node[:macos_defaults]

case defaults
when Hash
  from_hash defaults
when Array
  from_hash defaults
end
