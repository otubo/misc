#/bin/bash

# Still needs a lot of work to became an actual script.
# only listing commands of future reference

git remote update main_tree
git merge main_tree/master
git checkout seccomp
git merge master

# not sure if worth creating .next branch to get patches from automatically
# still applying patches manually

DATE=$(date +%Y%m%d)
TAG="pull-seccomp-${TAG}"

git push
git tag -s -m "seccomp branch queue" ${TAG} -u otubo
git push https://github.com/otubo/qemu.git ${TAG}
git format-patch --cover-letter <rev0>..<rev1> -o ~/
git request-pull <rev0> git://github.com/otubo/qemu.git ${TAG}
#git send-email --compose --annotate --to=qemu-devel@nongnu.org --to=peter.maydell@linaro.org  <cover-letter> <patches>
