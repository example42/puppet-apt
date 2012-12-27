# Define: apt::preferences
#
# Copy preferences to /etc/apt/preferences.d/ directory
#
# Usage:
#  + install a preference file for "packagename"
#  apt::preferences { "packagename": }
#  + uninstall a preference file
#  apt::preferences { "packagename": enabled => false, }
#

define apt::preferences (
    enabled='true'
) {
    file { "apt-preferences-${name}":
        path   => "/etc/apt/preferences.d/${name}",
        mode   => "0644",
        owner  => "root",
        group  => "root",
        ensure => $enabled ? {
	    'true'  => present,
	    default => absent,
	},
        source => ["puppet:///modules/apt/seat/${name}--${hostname}",
                   "puppet:///modules/apt/seat/${name}-${role}-${type}",
                   "puppet:///modules/apt/seat/${name}-${role}",
                   "puppet:///modules/apt/seat/${name}-${type}",
                   "puppet:///modules/apt/seat/${name}",
        ],
    }
}
