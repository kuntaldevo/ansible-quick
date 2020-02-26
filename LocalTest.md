## This Guide is for local test only. For Ansible Installation on AWS EC2 Instances, please refer to README.md in the same directory.

## tl;dr (for local test in MacOS only)

Get quick-automated-installation-master.zip from Paxata

On your MacOS:

Install vagrant https://www.vagrantup.com/downloads.html

Install virtualbox https://www.virtualbox.org/wiki/Downloads

Install Ansible
`>$ sudo easy_install pip`
`>$ sudo pip install ansible`

Install vagrant plugin
`>$ vagrant plugin install vagrant-hostmanager`

Import vagrant VM
`>$ vagrant box add geerlingguy/centos7`

Navigate to the ansible script directory
`>$ cd quick-automated-installation`

Start vagrant VM
`>$ vagrant up`

Run ansible script to install Paxata
`$ export ANSIBLE_HOST_KEY_CHECKING=False`
`$ ansible-playbook -i inventory.vagrant playbook.yml`

Check Paxata UI when playbook run is complete
https://core:8443

username: superuser
password: superuser

Detailed Steps

## Step 1 of 4 -- Install Ansible on Laptop

* [Install latest Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-on-mac-osx) (2.4 or above) on the control machine

   if on MacOS or WSL, run 
   `>$ sudo easy_install pip`

   `>$ sudo pip install ansible`
   `>$ sudo pip install jinja2`

## Step 2 of 4 -- Provision Target Servers -- Create Local Vagrant VMs (Local Test Only)

1. Download and Install Vagrant
   * [MacOS](https://www.vagrantup.com/downloads.html)
   * [Windows Subsystem for Linux (WSL)](https://www.vagrantup.com/docs/other/wsl.html)

1. [Download and install VirtualBox](https://www.virtualbox.org/wiki/Downloads)
   * For MacOS, download for OS X hosts
   * For Windows, even running in WSL, download for Windows hosts
      * Update WSL path for the Windows executable for VirtualBox  
      ```
      >$ vi ~/.bashrc
         
      export PATH="$PATH:/<path-to>/Oracle/VirtualBox"
      export VAGRANT_WSL_ENABLE_WINDOWS_ACCESS="1"
      
      >$ source ~/.bashrc
     
      * Run Command Prompt as Administator (_not_ WSL bash) and [disable Hypervisor](https://discuss.erpnext.com/t/virtualbox-wont-run-raw-mode-unavailable-courtesy-of-hyper-v/34541)
     
      $> bcdedit /set hypervisorlaunchtype off
     ```
      * Restart computer
      
1. [Install vagrant-hostmanager plugin](https://github.com/devopsgroup-io/vagrant-hostmanager/blob/master/README.md) to auto-update your `/etc/hosts` during `vagrant up` and `vagrant destroy`: 
   `>$ vagrant plugin install vagrant-hostmanager`

1. Unzip quick-automated-installation.zip
   `>$ cd quick-automated-installation`
   

1. Verify Vagrantfile already exists under quick-automated-installation directory: 
   `>$ cat Vagrantfile`

   *  In Vagrantfile, you can configure your VM by providing different IP addresses, larger VM memory etc.
   *  There's also a sample Vagrantfile for production-style infrastruture:  
   `>$ cat vagrantProd/Vagrantfile`

1. Add a CentOS 7.x 64-bit ‘box’ using the vagrant box add command:
   `>$ vagrant box add geerlingguy/centos7`

1. Make sure VirtualBox is installed by launching the VirtualBox app

1. Boot your CentOS servers:
   `>$ vagrant up`

1. Navigate to the VirtualBox application and you should see all VMs are in green (i.e., up) status.

1. Test SSH login to your VM. That's the last step of vangrant local VM deployment (password is `vagrant`): 
   `>$ ssh vagrant@core`

## Step 3 of 4 -- Configure host inventory file and playbook.yml

  + **mongo1/mongo2/mongo3/core/data/auto/pm/worker1/worker2/worker3** are psudo hostnames to be used in /etc/hosts for inter-server communication. You can leave them as is or change it to actual IP address.
  
  + **ansible_host** public or private IP addresses of the target servers used when SSH from the control machine

  + **private_ip** private IP addresses to be used in /etc/hosts file for inter-server communication
  
  + **ansible_ssh_user** and **ansible_ssh_private_key_file** to ssh user and private key to access all target/remote hosts

* In playbook.yml, go to the top "most configured values" section and update the values to your choice.

## Step 4 of 4: Run playbook to install Paxata

1. Skip hostname check on your control machine:
`$ export ANSIBLE_HOST_KEY_CHECKING=False`

1. Run the Ansible playbook with the inventory file (make sure your are still in quick-automated-installation directory): 
`$ ansible-playbook -i inventory.vagrant playbook.yml`

1. When prompted, enter your username and password to access https://flash.paxata.com/GA (if you don't have credentials to access https://flash.paxata.com/GA, please email servicedesk@paxata.com to request one)

1. When the playbook is run completed without error, go to Paxata UI using **public IP address or hostname** 

> https://core:8443

If you can see the Paxata UI, congratulations! You have installed Paxata!

## Questions?

Q: Can I pick whatever paxata version to install?

A: Sorry there's no way to pick the version, as the playbook only works with latest 2018.2 version on https://flash.paxata.com/GA/2018.2/

Q: What is the login available?

A: These are the default logins for any new paxata installation:

```
admin/admin
superuser/superuser
prodadmin/prodadmin
```
Q: Is there a limit on file size / row / column ?

A: Yes. These limits are calculated based on the total worker cores in your spark cluster (spark_worker_cores * number of hosts in spark-worker group in inventory). Formula is defined in playbook.yml. You can also change the guardrail in Admin -> Global default guardrail in the Paxata UI as "superuser"

Q: In Vagrant Local VM deloyment, if I want to destroy the VMs and reinstall Paxata afresh, What should I do?

A: It's easy. Just three commands:

`$ vagrant destroy`

`$ vagrant up`

Navigate to your quick-automated-installation directory

Rerun the playbook

`$ ansible-playbook -i inventory.vagrant playbook.yml`

For any other questions, please email `servicedesk@paxata.com`

Q: How can I skip certain tasks?

A: Currently there are two things you can skip: 1. upload mongodump to S3; 2. run IOPS test on spark worker. To skip them, run playbook with --skip-tags

`$ ansible-playbook -i inventory.xxx playbook.yml --skip-tags=mongodump_upload,iops_test`

Q: Why did the task "boostrap: Download Paxata Server Versin File" fail with "HTTP Error 401: basic auth failed"?

A: That means your flash server credential is invalid. Please rerun the playbook and enter the valid credential when prompted.

Q: When using local vagrant VMs, how do I start/stop/destroy the VMs?

A: * Common Vagrant commands
  + If you want to stop the VMs. Data will not be lost.
    `vagrant halt`

  + If you want to destroy the VMs. Data will be lost.
    `vagrant destroy`

  + After destroying the VM, you can easily recreate the VMs.
    `vagrant up`

A: If your target hosts do not have Internet access, follow these steps:

```
On core server, install httpd
  sudo yum -y install httpd

Edit /etc/httpd/conf/httpd.conf 
  change "Listen 80" to "Listen 8414"

Create a subdirectory for httpd
  mkdir /var/www/html/pax


From any host with Internet access, download Paxata bundle.zip and upload it to core server
  wget --user xxxx --ask-password --no-check-certificate https://flash.paxata.com//2018.2/ansible/bundle.tgz


Unzip the bundle to /var/www/html/pax and set correct permission
  tar -zvxf bundle.tgz -C /var/www/html/pax/
  chmod -R ugo+rX /var/www/html/pax/

Start httpd server
  service httpd restart

In browser: navigate to http://core:8414/pax/efs/flash/GA/2018.2/ to ensure all files are accessible

Install Open JDK and bind-utils on all target servers:
  sudo yum install -y java-1.8.0-openjdk-devel
  sudo yum install -y bind-utils

Update playbook.yml, comment out the ###Remote Repository URL### section and uncomment the ###Local Repository URL### section

Run the playbook
  ansible-playbook -i inventory. vagrant playbook.yml

```