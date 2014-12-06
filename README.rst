cloud-init-start
=================

Quickly bring up Ubuntu or FC20 Cloud instances in local
KVM with virsh using cloud-config.

Requirements:

 * Make
 * wget
 * cloud-utils (cloud-localds)
 * qemu/kvm
 * libvirt (virsh)
 * virtinst (virt-install)

Usage:

.. code-block:: shell

   # Define cloud-config data
   $ editor myhost01.user-data

The cloud-config user data looks something like this:

.. code-block:: yaml
   
   #cloud-config
   hostname: example
   manage_etc_hosts: True
   
   ssh_pwauth: False
   
   ssh_authorized_keys:
    - ssh-rsa AAAAB.....
   
   package_upgrade: true

You can find more examples of what you can do with cloud-config
from the `cloud-init documentation <http://cloudinit.readthedocs.org/en/latest/topics/examples.html>`_.

If you saved the cloud-config to file myhost01.example, you can
now launch a virtual machine.

.. code-block:: shell

   # Ubuntu 14.04 Trusty
   $ make ubuntu-myhost01
   
     OR
   
   # Fedora Core 20
   $ make fc20-myhost01

The Makefile:

 1. downloads the base cloud image (reused for new VMs),
 2. creates a root disk image for it, packages the user-data
    to an ISO 9660 file, and
 3. defines the machine with virt-install so it can be started.

You can now start the VM with:

.. code-block:: shell

   $ virsh start myhost01

What you do with your VM after this is up to you.
