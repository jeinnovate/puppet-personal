node default {
  $user = 'jonathan'
  include ubuntu_general

  class { 'ohmyzsh':  }

  ohmyzsh::install { $user: }

  class { 'nvm_nodejs':
    user => $user,
    version => '0.10.29',
  }

  include rvm

  rvm::system_user { jonathan: ; }

  rvm_system_ruby {
    'ruby-2.1.2':
      ensure      => 'present',
      default_use => true;
    'ruby-1.9':
      ensure      => 'present',
      default_use => false;
  }
}
