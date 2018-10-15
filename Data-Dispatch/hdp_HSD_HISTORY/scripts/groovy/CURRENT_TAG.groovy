/** Added new comments for jenskins job testing
 * This script is used under Jenkins jobs
 *      + DDSW - Release
 */

proc = ['/bin/bash', '-c', "/usr/local/bin/git config --global credential.helper store"].execute()

proc1 = ['/bin/bash', '-c', "/usr/local/bin/git pull --rebase"].execute()

proc2 = ['/bin/bash', '-c', "git describe --abbrev=0 --tags"].execute()

return proc2.text
