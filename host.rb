#!/usr/bin/env ruby

require 'dyn-rb'

$zone = ARGV[0]
$fqdn = "_acme-challenge.#{$zone}"
$token = ARGV[1]
$cleanup = ARGV[2] ? true : false

DYN_ACCOUNTNAME = ENV["DYN_ACCOUNTNAME"]
DYN_USERNAME    = ENV["DYN_USERNAME"]
DYN_PASSWORD    = ENV["DYN_PASSWORD"]

def base_zone
  s = $zone.split(".")
  "#{s[-2]}.#{s[-1]}"
end

$dyn = Dyn::Traffic::Client.new(DYN_ACCOUNTNAME, DYN_USERNAME, DYN_PASSWORD, base_zone)

def zone_exists
  begin
    z = $dyn.zone.get
    return z["zone"] == base_zone
  rescue Dyn::Exceptions::RequestFailed => e
  end
  false
end

def record_exists
  begin
    txt = $dyn.txt.get($fqdn)
    return txt.rdata.has_key?("txtdata")
  rescue Dyn::Exceptions::RequestFailed => e
  end
  false
end

if !zone_exists
  puts " + unable to manage requests for #{base_zone}"
  $dyn.logout
  exit 1
end

if !$cleanup
  replace = record_exists
  puts " + saving TXT record #{$fqdn} => #{$token}, replace: #{replace}"
  $dyn.txt.fqdn($fqdn).ttl(1).txtdata("#{$token}").save(replace)
  $dyn.zone.publish
  sleep 5
else
  puts " + removing TXT record #{$fqdn}"
  $dyn.txt.fqdn($fqdn).delete
  $dyn.zone.publish
  sleep 5
end

$dyn.logout

