# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v3.3.0](https://github.com/voxpupuli/puppet-quadlets/tree/v3.3.0) (2025-11-24)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v3.2.0...v3.3.0)

**Implemented enhancements:**

- add generation of auth.json file for users \(on request\) [\#88](https://github.com/voxpupuli/puppet-quadlets/pull/88) ([trefzer](https://github.com/trefzer))
- Quadlet creation in `/etc/containers/systemd/users/<user>` [\#87](https://github.com/voxpupuli/puppet-quadlets/pull/87) ([traylenator](https://github.com/traylenator))

## [v3.2.0](https://github.com/voxpupuli/puppet-quadlets/tree/v3.2.0) (2025-11-19)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Support more Health container parameters [\#84](https://github.com/voxpupuli/puppet-quadlets/pull/84) ([traylenator](https://github.com/traylenator))
- Allow Pod names with numbers \> 0 in Quadlets::Unit::Container type alias [\#83](https://github.com/voxpupuli/puppet-quadlets/pull/83) ([stdietrich](https://github.com/stdietrich))

## [v3.1.0](https://github.com/voxpupuli/puppet-quadlets/tree/v3.1.0) (2025-11-15)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v3.0.0...v3.1.0)

**Implemented enhancements:**

- allow for broader AddDevice type spec to include CDI devices [\#80](https://github.com/voxpupuli/puppet-quadlets/pull/80) ([edrude](https://github.com/edrude))

**Fixed bugs:**

- the correct selbool ends in \_cgroup, not \_group [\#81](https://github.com/voxpupuli/puppet-quadlets/pull/81) ([edrude](https://github.com/edrude))

## [v3.0.0](https://github.com/voxpupuli/puppet-quadlets/tree/v3.0.0) (2025-11-07)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v2.2.1...v3.0.0)

**Breaking changes:**

- Redefine how quadlet users are setup [\#76](https://github.com/voxpupuli/puppet-quadlets/pull/76) ([traylenator](https://github.com/traylenator))

**Implemented enhancements:**

- Addition of quadlets.podman\_version fact [\#77](https://github.com/voxpupuli/puppet-quadlets/pull/77) ([traylenator](https://github.com/traylenator))
- Support setting subuid and subgid entries [\#75](https://github.com/voxpupuli/puppet-quadlets/pull/75) ([traylenator](https://github.com/traylenator))
- Declare puppet-systemd \<= 9 support [\#74](https://github.com/voxpupuli/puppet-quadlets/pull/74) ([traylenator](https://github.com/traylenator))
- Add Debian 13 support [\#73](https://github.com/voxpupuli/puppet-quadlets/pull/73) ([traylenator](https://github.com/traylenator))
- Use search path for quadlets during validation [\#72](https://github.com/voxpupuli/puppet-quadlets/pull/72) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- Explicitly create the group of quadlet user [\#70](https://github.com/voxpupuli/puppet-quadlets/pull/70) ([traylenator](https://github.com/traylenator))
- Validate new quadlet with existing quadlets [\#61](https://github.com/voxpupuli/puppet-quadlets/pull/61) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Add tests for `quadlet::user` [\#68](https://github.com/voxpupuli/puppet-quadlets/pull/68) ([traylenator](https://github.com/traylenator))

## [v2.2.1](https://github.com/voxpupuli/puppet-quadlets/tree/v2.2.1) (2025-10-24)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v2.2.0...v2.2.1)

**Fixed bugs:**

- Correct name of image services [\#63](https://github.com/voxpupuli/puppet-quadlets/pull/63) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Addition of rootless example to README [\#64](https://github.com/voxpupuli/puppet-quadlets/pull/64) ([traylenator](https://github.com/traylenator))

## [v2.2.0](https://github.com/voxpupuli/puppet-quadlets/tree/v2.2.0) (2025-10-23)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v2.1.0...v2.2.0)

**Implemented enhancements:**

- Allow to configure UserNS mode on Pods [\#65](https://github.com/voxpupuli/puppet-quadlets/pull/65) ([stdietrich](https://github.com/stdietrich))
- Correct PublishPort and add Label and Hostname to Pods [\#59](https://github.com/voxpupuli/puppet-quadlets/pull/59) ([traylenator](https://github.com/traylenator))

**Fixed bugs:**

- Correct Hostname to HostName [\#60](https://github.com/voxpupuli/puppet-quadlets/pull/60) ([traylenator](https://github.com/traylenator))

## [v2.1.0](https://github.com/voxpupuli/puppet-quadlets/tree/v2.1.0) (2025-10-06)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v2.0.0...v2.1.0)

**Implemented enhancements:**

- Validate quadlet files before they are written [\#53](https://github.com/voxpupuli/puppet-quadlets/pull/53) ([traylenator](https://github.com/traylenator))
- Support dependencies between quadlets [\#52](https://github.com/voxpupuli/puppet-quadlets/pull/52) ([traylenator](https://github.com/traylenator))
- Added location to drop ENC defined quadlets [\#51](https://github.com/voxpupuli/puppet-quadlets/pull/51) ([jcpunk](https://github.com/jcpunk))
- Support CentOS, Rocky, Alma, Oracle 10 and Fedora 42 [\#42](https://github.com/voxpupuli/puppet-quadlets/pull/42) ([traylenator](https://github.com/traylenator))
- Support rootless quadlets, add user option to quadlet [\#41](https://github.com/voxpupuli/puppet-quadlets/pull/41) ([tjikkun](https://github.com/tjikkun))

**Closed issues:**

- Would You Consider Support for Rootless/User Containers? [\#19](https://github.com/voxpupuli/puppet-quadlets/issues/19)

## [v2.0.0](https://github.com/voxpupuli/puppet-quadlets/tree/v2.0.0) (2025-08-28)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v1.2.0...v2.0.0)

**Breaking changes:**

- Drop puppet, update openvox minimum version to 8.19 [\#39](https://github.com/voxpupuli/puppet-quadlets/pull/39) ([TheMeier](https://github.com/TheMeier))

**Implemented enhancements:**

- Add support for multiple networks for one container  [\#48](https://github.com/voxpupuli/puppet-quadlets/pull/48) ([LukasSchulte1](https://github.com/LukasSchulte1))
- Add network units [\#46](https://github.com/voxpupuli/puppet-quadlets/pull/46) ([saimonn](https://github.com/saimonn))
- Add option to specify entrypoint [\#45](https://github.com/voxpupuli/puppet-quadlets/pull/45) ([tjikkun](https://github.com/tjikkun))
- Add support for image quadlet type [\#43](https://github.com/voxpupuli/puppet-quadlets/pull/43) ([tjikkun](https://github.com/tjikkun))
- Add missing options for container units [\#38](https://github.com/voxpupuli/puppet-quadlets/pull/38) ([jcpunk](https://github.com/jcpunk))
- Permit custom name/state for podman packages [\#37](https://github.com/voxpupuli/puppet-quadlets/pull/37) ([jcpunk](https://github.com/jcpunk))
- Add management of the autoupdate timer [\#36](https://github.com/voxpupuli/puppet-quadlets/pull/36) ([jcpunk](https://github.com/jcpunk))
- Add manage\_service option to disable service management [\#32](https://github.com/voxpupuli/puppet-quadlets/pull/32) ([jorhett](https://github.com/jorhett))
- Add support for .network quadlets [\#29](https://github.com/voxpupuli/puppet-quadlets/pull/29) ([night199uk](https://github.com/night199uk))
- Make podman package management optional [\#28](https://github.com/voxpupuli/puppet-quadlets/pull/28) ([jorhett](https://github.com/jorhett))

**Fixed bugs:**

- test: explicitly configure fuse-overlayfs for archlinux [\#35](https://github.com/voxpupuli/puppet-quadlets/pull/35) ([TheMeier](https://github.com/TheMeier))

**Merged pull requests:**

- README.md: please puppet-lint for code examples [\#27](https://github.com/voxpupuli/puppet-quadlets/pull/27) ([bastelfreak](https://github.com/bastelfreak))

## [v1.2.0](https://github.com/voxpupuli/puppet-quadlets/tree/v1.2.0) (2025-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v1.1.0...v1.2.0)

**Implemented enhancements:**

- add management of container\_manage\_cgroup selboolean [\#25](https://github.com/voxpupuli/puppet-quadlets/pull/25) ([edrude](https://github.com/edrude))
- metadata.json: Add OpenVox [\#24](https://github.com/voxpupuli/puppet-quadlets/pull/24) ([jstraw](https://github.com/jstraw))

**Merged pull requests:**

- puppet/systemd: allow 8.x [\#20](https://github.com/voxpupuli/puppet-quadlets/pull/20) ([jay7x](https://github.com/jay7x))

## [v1.1.0](https://github.com/voxpupuli/puppet-quadlets/tree/v1.1.0) (2024-09-20)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v1.0.1...v1.1.0)

**Implemented enhancements:**

- add purge\_quadlet\_dir param [\#17](https://github.com/voxpupuli/puppet-quadlets/pull/17) ([jhoblitt](https://github.com/jhoblitt))

## [v1.0.1](https://github.com/voxpupuli/puppet-quadlets/tree/v1.0.1) (2024-09-10)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/v1.0.0...v1.0.1)

**Fixed bugs:**

- allow container\_entry.{User,Group} to be String or Integer [\#12](https://github.com/voxpupuli/puppet-quadlets/pull/12) ([jhoblitt](https://github.com/jhoblitt))

**Merged pull requests:**

- FacterDB: Switch to stringified keys [\#13](https://github.com/voxpupuli/puppet-quadlets/pull/13) ([bastelfreak](https://github.com/bastelfreak))

## [v1.0.0](https://github.com/voxpupuli/puppet-quadlets/tree/v1.0.0) (2024-09-06)

[Full Changelog](https://github.com/voxpupuli/puppet-quadlets/compare/ad5ca32eb9895a23bfe21095ae92e6f876a816d2...v1.0.0)

**Implemented enhancements:**

- add metadata.json tags [\#10](https://github.com/voxpupuli/puppet-quadlets/pull/10) ([jhoblitt](https://github.com/jhoblitt))
- New parameter for quadlet directory creation. [\#6](https://github.com/voxpupuli/puppet-quadlets/pull/6) ([traylenator](https://github.com/traylenator))
- Add Kube type quadlet support [\#5](https://github.com/voxpupuli/puppet-quadlets/pull/5) ([dabelenda](https://github.com/dabelenda))
- Add `quadlets::quadlet` type to manage quadlet files [\#4](https://github.com/voxpupuli/puppet-quadlets/pull/4) ([traylenator](https://github.com/traylenator))
- Install and Manage Podman Socket [\#3](https://github.com/voxpupuli/puppet-quadlets/pull/3) ([traylenator](https://github.com/traylenator))

**Merged pull requests:**

- Add puppet-quadlets badges to README.md [\#7](https://github.com/voxpupuli/puppet-quadlets/pull/7) ([traylenator](https://github.com/traylenator))



\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
