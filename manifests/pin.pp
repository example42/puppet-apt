# Define: apt::pin
#
# Pinning packages
#
# Usage:
#  apt::pin { "packageName":
#      version  => "version to pin (optional)",
#      release  => "release to pin (optional)",
#      priority => "pin priority",
#  }
#
# You need to set at least version or release to pin.
#
# For example, to forcing installation of cassandra 0.7.5, you can pin it:
#
#   apt::pin { "cassandra":
#       version  => "0.7.5",
#       priority => "1001",
#   } 
#
# Or, you can force installation of firefox from the intrepid release
#
#    apt::pin { "firefox-3.0":
#        release  => "intrepid",
#        priority => "900",
#    }
#

define apt::pin ( 
    $version='',
    $release='',
    $priority='',
    $ensure="present"
) {

    if $version != '' {
        file { "/etc/apt/preferences.d/pin-${name}":
            owner   => "root",
            group   => "root",
            mode    => "644",
            content => template("apt/pin-version.erb"), 
            ensure  => $ensure,
        }
    } else {
        file { "/etc/apt/preferences.d/pin-${name}":
            owner   => "root",
            group   => "root",
            mode    => "644",
            content => template("apt/pin-release.erb"), 
            ensure  => $ensure,
        }
    }
}
