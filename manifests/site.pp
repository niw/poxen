node default {
  # This is required to apply some manifests since these are not using
  # appropriate user, group or full path to the command.
  Exec {
    group => "staff",
    user => $boxen_user,
    path => [
      "/usr/local/bin",
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "sbin"
    ]
  }

  # This is also required to apply some manifests correctly.
  File {
    group => "staff",
    owner => $boxen_user
  }

  # Run all defaults command as login user.
  Boxen::Osx_defaults {
    user => $boxen_user
  }

  # Your manifests goes here.
}
