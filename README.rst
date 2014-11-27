ubuntu-cloud-init
=================

Quickly bring up Ubuntu Cloud instances in local KVM with virsh using cloud-init

Usage:

.. code-block::

   $ cp example.user-data myhost01.user-data
   $ make create-myhost01
   $ virsh start myhost01
   ...
   PROFIT
