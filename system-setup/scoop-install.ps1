<#
 .SYNOPSIS
  Scoop install script

.DESCRIPTION
  Install scoop, all given applications and configure confg/pshazz.

.INPUTS
  None

.OUTPUTS
  None
 #>

## 1. Install scoop if not installed
if (Get-Command scoop -errorAction SilentlyContinue) {
  echo 'Scoop is already installed.'
}
else {
  Set-ExecutionPolicy RemoteSigned -scope CurrentUser
  iex (new-object net.webclient).downloadstring('https://get.scoop.sh')
}
scoop install git-with-openssh
[environment]::setenvironmentvariable('GIT_SSH', (resolve-path (scoop which ssh)), 'USER')
scoop update
## 2. Add java bucket and install tools
scoop bucket add java
scoop bucket add extras
scoop install 7zip concfg go gpg4win gradle groovy maven nodejs notepadplusplus openjdk openshift-origin-client openssl oraclejdk8 putty vim jetbrains-toolbox keepass rocketchat-client windirstat
#scoop install python
concfg export console-backup.json
concfg import solarized-dark
scoop install pshazz
