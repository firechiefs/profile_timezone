## PURPOSE:

Sets time zone based on values in hiera

## HIERA DATA:
Determining valid timezones:

--> windows: ```'[System.TimeZoneInfo]::GetSystemTimeZones()'```

--> RedHat:
```'ll /usr/share/zoneinfo'```

Determining validation timezone:

--> ``` 'facter -p hostname' ```

## HIERA EXAMPLE:
```
  profile::timezone:
    RedHat: "America/Los_Angeles"
    windows: "Pacific Standard Time"
    validation:
      RedHat: "PST"
      windows: "Pacific Standard Time"
```

## MODULE DEPENDENCIES:
```
puppet module install saz-timezone
puppet module install puppetlabs-dsc
```
## USAGE:

#### Puppetfile:
```
mod "saz-timezone",          '3.3.0'

mod 'puppetlabs-dsc',
  :git => 'https://github.com/puppetlabs/puppetlabs-dsc',
  :tag => '1.0.0'

mod 'validation_script',
  :git => 'https://github.com/firechiefs/validation_script',
  :ref => '1.0.0'

mod 'profile_timezone',
  :git => 'https://github.com/firechiefs/profile_timezone',
  :ref => '1.0.0'
```
#### Manifests:
```
class role::*rolename* {
  include profile_timezone
}
```
