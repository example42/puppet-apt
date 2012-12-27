# Define: apt::key
#
# Add key to keyring
#
# Usage:
#  apt::key { "key id":
#      url => 'key url',
#  }
#
# For example, to add the standard Seat key, you can use
#
#   apt::key { "952C4F3A":
#       url => "http://debian.pgol.com/seat/seat.asc",
#   } 
#

define apt::key ( 
    $url='',
    $proxy='',
    $keyserver='',
    $fingerprint=''
) {
    if $url != '' {
        exec { "aptkey_add_${name}":
            command => "wget -O - ${url} | apt-key add -",
            unless  => "apt-key list | grep -q ${name}",
        }
    } else {
        exec { "aptkey_adv_${name}":
            command => "apt-key adv --keyserver ${keyserver} --recv ${fingerprint}",
            environment => $proxy ? {
                ''      => "",
                default => "http_proxy=${proxy}",
            },
            unless  => "apt-key list | grep -q ${name}",
        }
    }
}
