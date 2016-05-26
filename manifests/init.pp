# PURPOSE:
# sets time zone based on values in hiera
#
# HIERA DATA:
# Determining valid timezones:
# --> windows: '[System.TimeZoneInfo]::GetSystemTimeZones()'
# --> RedHat:  'll /usr/share/zoneinfo'
# Determining validation timezone:
# --> 'facter -p hostname'
#
# HIERA EXAMPLE:
# profile::timezone:
#    RedHat: "America/Los_Angeles"
#    windows: "Pacific Standard Time"
#    validation:
#      RedHat: "PST"
#      windows: "Pacific Standard Time"
#
# MODULE DEPENDENCIES:
# puppet module install saz-timezone
# puppet module install puppetlabs-dsc

class profile_timezone {
  # A windows VM that is building for the first time will not have the
  # necessary foundation to try to apply dsc types for timezone.
  # require that profile::base completes before this class declaration.
  require profile::base
  # HIERA LOOKUP:
  # --> PUPPET CODE VARIABLES:
  $timezone            = hiera("profile::timezone.${::osfamily}")
  $timezone_validation =
    hiera("profile::timezone.validation.${::osfamily}")

  # HIERA LOOKUP VALIDATION:
  validate_string($timezone)
  validate_string($timezone_validation)

  # PUPPET CODE:
  # sets timezone based on osfamily
  case $::osfamily {
    'RedHat': { class { 'timezone': timezone => $timezone } }
    'windows': {
      dsc_xtimezone { 'timezone':
        dsc_timezone         => $timezone,
        dsc_issingleinstance => 'Yes',
      }
    }
    default: { fail("profile::timezone not supported on ${::osfamily} !!!") }
  }

  # VALIDATION CODE:
  # --> MODIFY VARIABLES BELOW:
  $profile_name    = 'profile_timezone'           # set to profile name
  $validation_data = $timezone_validation # set to data you'd like to validate

  # Puppet custom define type
  # documented in: site/validation_script/manifests/init.pp
  # DO NOT MODIFY BELOW !!!
  validation_script { $profile_name:
    profile_name    => $profile_name,
    validation_data => $validation_data,
  }

}
