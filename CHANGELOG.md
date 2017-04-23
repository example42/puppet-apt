## Release 2.1.1
### Summary
A release targeting puppetlabs-apt compatibility.

#### Features
- apt::update copied and adapted from puppetlabs-apt

### Backward incompatible changes
- Class[apt::aptget\_update] and Exec[aptget\_update] are removed, use Class[apt::update] in notify instead

## Release 2.1.0
### Summary
A release targeting puppetlabs-apt compatibility.

#### Features
- apt::key copied and adapted from puppetlabs-apt
- apt::setting copied and adapted from puppetlabs-apt
- apt::source copied and adapted from puppetlabs-apt

### Deprecations
- apt::key parameters url, keyserver and fingerprint are deprecated and should be replaced by source, server and id
- apt::key parameters environment and path are deprecated and ignored
- apt::repository is deprecated, use apt::source instead

