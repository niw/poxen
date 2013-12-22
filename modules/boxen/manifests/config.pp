# Public: Set up necessary Boxen configuration
#
# Usage:
#
#   include boxen::config

class boxen::config {
  $home              = $::boxen_home
  $bindir            = "${home}/bin"
  $cachedir          = "${home}/cache"
  $configdir         = "${home}/config"
  $datadir           = "${home}/data"
  $envdir            = "${home}/env.d"
  $homebrewdir       = "${home}/homebrew"
  $logdir            = "${home}/log"
  $repodir           = $::boxen_repodir
  $reponame          = $::boxen_reponame
  $socketdir         = "${datadir}/project-sockets"
  $srcdir            = $::boxen_srcdir
  $login             = $::github_login
  $repo_url_template = $::boxen_repo_url_template
}
