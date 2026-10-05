# @summary Creates a file per user as input to the quadlets fact
#
# @param user Username to configure quadlets fact for
#
define quadlets::user_fact_conf (
  String[1] $user = $title,
) {
  # First puppet run maintains a file for each user of rootless quadlets

  include quadlets

  file { "/var/lib/quadlets-users-fact.d/${user}":
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
  }

  # Next puppet run the quadlets.users facts will be populated for
  # this user.
}
