FROM centos:6.9

MAINTAINER "navid.hsz"

USER root

ENV JDK_VERSION 1.8.0_201-amd64
ENV TERM=xterm
ENV JCE_POLICY_DOWNLOAD_PATH http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip
ENV JAVA_HOME /usr/java/jdk$JDK_VERSION
ENV PATH $PATH:$JAVA_HOME/bin
ENV PYTHONPATH="/usr/lib/python2.7/site-packages/":$PYTHONPATH

RUN yum install -y epel-release initscripts openssh-server openssh-clients sudo tar unzip vim wget curl gpg; \
    yum install -y krb5-libs krb5-server krb5-auth-dialog krb5-workstation net-tools openldap-clients nano jq nc telnet lsof; \
    yum install -y scl-utils; \
    yum install -y centos-release-scl; \
    yum install -y python27; \
    curl -v -L -b -O https://download.postgresql.org/pub/repos/yum/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-3.noarch.rpm > pgdg-centos94-9.4-3.noarch.rpm; \
    rpm -ivh pgdg-centos94-9.4-3.noarch.rpm; \
    yum -y install postgresql94; \
    scl enable python27 bash; \
    chkconfig sshd on; \
    curl -v -O -L -b oraclelicense=accept-securebackup-cookie "https://download.oracle.com/otn-pub/java/jdk/8u201-b09/42970487e3af4f5aa5bca3f542482c60/jdk-8u201-linux-x64.rpm"; \
    yum -y localinstall jdk-8u201-linux-x64.rpm; \
    yum clean all; \
    rm jdk-8u201-linux-x64.rpm; \
    curl -v -L -b oraclelicense=accept-securebackup-cookie $JCE_POLICY_DOWNLOAD_PATH > /tmp/JCE.zip; \
    unzip -d /tmp/ /tmp/JCE.zip; \
    cp -vf /tmp/UnlimitedJCEPolicy*/US_export_policy.jar /usr/java/jdk$JDK_VERSION/jre/lib/security/; \
    cp -vf /tmp/UnlimitedJCEPolicy*/local_policy.jar /usr/java/jdk$JDK_VERSION/jre/lib/security/; \
    rm -rf /tmp/*; \
    echo 'export PYTHONPATH="/usr/lib/python2.7/site-packages/":$PYTHONPATH' >> /etc/profile; \
    echo "root:root" | chpasswd; \
    service sshd restart