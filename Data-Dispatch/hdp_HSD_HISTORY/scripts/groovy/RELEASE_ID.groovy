/** Removing comments 
 * IMPORTANT
 * Make sure /tmp/releases.txt is accessible for Read, Write and Execute
 * Make sure the special characters (`) are retained in this statement
 *      + `git rev-list --tags --max-count=4`
 *
 * This script is used under Jenkins Jobs
 *      + DDSW Deploy - CICD
 *      + DDSW Deploy - DEV
 *      + DDSW Deploy - QA
 *      + DDSW Deploy - ONBOARDING
 *      + DDSW Deploy - PROD
 */

proc = ['/bin/bash', '-c', "/usr/local/bin/git config --global credential.helper store"].execute()

proc1 = ['/bin/bash', '-c', "/usr/local/bin/git pull --rebase"].execute()

proc2 = ['/bin/bash', '-c', "git describe --tags --abbrev=0 `git rev-list --tags --max-count=2`"].execute()
proc3 = ['/bin/bash', '-c', "sed s%^ddsw-%%"].execute()

all = proc2 | proc3
String result = all.text

String filename = "tmp/releases.txt"
boolean success = new File(filename).write(result)

def multiline = "cat tmp/releases.txt".execute().text
def list = multiline.readLines()

for(def listItem : list) {
    System.out.println("List Item :-> " + listItem)
}

return list
