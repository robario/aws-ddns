#! /bin/bash
#
# @(#) install.sh -- Install awsddns as a service
#
set -o nounset
set -o errexit

cd /etc/init.d
curl --silent --remote-name https://raw.githubusercontent.com/robario/awsddns/master/awsddns
chmod 0755 ./awsddns
chkconfig --del awsddns
chkconfig --add awsddns
