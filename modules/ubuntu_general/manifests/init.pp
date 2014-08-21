include wget
include apt

class ubuntu_general {
  $required_packages = [
    'nautilus-image-converter',
    'p7zip-full',
    'p7zip-rar',
    'openjdk-7-jdk',
    'icedtea-7-plugin',
    'maven',
    'gpart',
    'alacarte',
    'vim',
    'ssh',
    'filezilla',
    'git',
    'screen',
    'tmux',
    'curl',
    'exuberant-ctags',
    'zsh',
    'htop',
    'tree',
    'python-pip',
    'libnotify-bin',
    'xclip',
    'ubuntu-restricted-extras',
    'virtualbox'
  ]
  package { $required_packages: ensure => present, }

  $teamviewer_location='/tmp/teamviewer_linux.deb'
  wget::fetch { 'http://download.teamviewer.com/download/teamviewer_linux.deb':
    destination => $teamviewer_location,
    cache_dir   => '/var/cache/wget',
  }

  $required_teamviewer = [
    'gcc-4.9-base:i386',
    'libasound2:i386',
    'libc6:i386',
    'libfreetype6:i386',
    'libgcc1:i386',
    'libice6:i386',
    'libpng12-0:i386',
    'libsm6:i386',
    'libuuid1:i386',
    'libx11-6:i386',
    'libxau6:i386',
    'libxcb1:i386',
    'libxdamage1:i386',
    'libxdmcp6:i386',
    'libxext6:i386',
    'libxfixes3:i386',
    'libxrandr2:i386',
    'libxrender1:i386',
    'libxtst6:i386',
    'zlib1g:i386'
  ]
  package { $required_teamviewer: ensure => present, }

  package { 'teamviewer9':
    ensure => present,
    provider => dpkg,
    source => $teamviewer_location,
  }

  class { 'apt': }

  apt::ppa { 'ppa:stefansundin/truecrypt': }

  package { 'truecrypt': ensure => present, }

  exec { 'partner':
    path => '/usr/bin:usr/sbin:/bin',
    command => 'sudo apt-add-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"&& sudo apt-get update',
    unless => 'cat /etc/apt/sources.list | grep "^deb http://archive.canonical.com/ubuntu" 2>/dev/null',
  }

  package { 'skype': ensure => present, }

  class { 'awscli': }

  $user='jonathan'
  exec {'spf13':
    path => '/usr/bin:usr/sbin:/bin',
    command => 'curl http://j.mp/spf13-vim3 -L | bash -s',
    creates => "/home/${user}/.spf13-vim-3",
    logoutput => true,
    user => $user,
    environment => "HOME=/home/${user}"
  }
}
