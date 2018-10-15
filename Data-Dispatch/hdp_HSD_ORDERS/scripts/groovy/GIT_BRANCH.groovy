/**
 * IMPORTANT
 * Make sure /tmp/branches.txt is accessible for Read, Write and Execute
 *
 * This script is used under Jenkins Jobs
 *      + DDSW - Branch CI
 *      + DDSW - Release
 */

proc = ['/bin/bash', '-c', "/usr/local/bin/git config --global credential.helper store"].execute()

proc1 = ['/bin/bash', '-c', "/usr/local/bin/git pull --rebase"].execute()

proc2 = ['/bin/bash', '-c', "/usr/local/bin/git ls-remote -h https://arlgitgisp01.ecorp.cat.com/commercial_data_management/ddsw_dev.git"].execute()
proc3 = ['/bin/bash', '-c', "awk '{print \$2}'"].execute()
proc4 = ['/bin/bash', '-c', "sed s%^refs/heads/%%"].execute()

all = proc2 | proc3 | proc4
String result = all.text

String filename = "/tmp/branches.txt"
boolean success = new File(filename).write(result)

def multiline = "cat /tmp/branches.txt".execute().text
def list = multiline.readLines()