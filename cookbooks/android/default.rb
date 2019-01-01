include_cookbook 'java'

if node[:platform] == 'darwin'
  cask 'android-sdk'
  cask 'android-studio'
end

package 'pidcat'
