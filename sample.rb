if ARGV.length != 2
  raise "Expected use: ruby sample.rb username password"
end

require_relative 'rest_client'

c = UltraRestApi::RestClient.new(ARGV[0], ARGV[1])
puts c.version
puts c.status
account_details = c.get_account_details
account_name = account_details['list'][0]['accountName']
puts account_name
puts c.create_primary_zone(account_name, 'foo.invalid.')
puts c.get_zone_metadata 'foo.invalid.'
puts c.delete_zone 'foo.invalid.'
all_zones = c.get_zones_of_account(account_name, q: {zone_type:'PRIMARY'}, offset: 0, limit: 5)
first_zone_name = all_zones['list'][0]['zoneProperties']['name']
puts first_zone_name
puts c.get_rrsets first_zone_name
puts c.create_rrset(first_zone_name, 'A', 'foo', 300, '1.2.3.4')
puts c.get_rrsets first_zone_name
puts c.get_rrsets_by_type(first_zone_name, 'A')
# the value returned from update rrset is broken.
# the operation is performed correctly, but
# it returns a GUID instead of JSON,
# so the python code will throw an error
# the next release of the REST API server fixes this bug
#puts c.edit_rrset(first_zone_name, "A", "foo", 100, ["10.20.30.40"])
puts c.get_rrsets first_zone_name
puts c.get_rrsets_by_type(first_zone_name, 'A')
puts c.delete_rrset(first_zone_name, 'A', 'foo')
puts c.get_rrsets first_zone_name
puts c.get_rrsets_by_type(first_zone_name, 'A')