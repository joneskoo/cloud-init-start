cloud-init-start
=================

Quickly bring up Ubuntu or FC20 Cloud instances in local
KVM with virsh using cloud-config.

Usage:

.. code-block::

   # Define cloud-config data
   $ cp example.user-data myhost01.user-data
   $ editor myhost01.user-data

   $ make ubuntu-myhost01
     OR
   $ make fc20-myhost01

   $ virsh start myhost01

   ??????

   PROFIT
