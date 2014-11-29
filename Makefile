#################################################
## ORIGINAL OFFICIAL IMAGES

dist:
	mkdir dist

dist/trusty-server-cloudimg-amd64-disk1.img: dist
	wget -O $@ https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

# Fedora
dist/Fedora-x86_64-20-20140407-sda.qcow2: dist
	wget -O $@ http://download.fedoraproject.org/pub/fedora/linux/updates/20/Images/x86_64/Fedora-x86_64-20-20140407-sda.qcow2
	(cd dist && \
	 echo "ffd240c32b676179608e50d8640fcd1ac6b9bb67f1486c703c47b51dc52daf2f *Fedora-x86_64-20-20140407-sda.qcow2" \
	 | shasum -c)

.PRECIOUS: dist/Fedora-x86_64-20-20140407-sda.qcow2 dist/trusty-server-cloudimg-amd64-disk1.img

#################################################
## Unpack and expand

# Ubuntu
ubuntu-trusty-amd64-10GB-root.qcow2: dist/trusty-server-cloudimg-amd64-disk1.img
	qemu-img convert -O qcow2 $< $@
	qemu-img resize $@ +8G

fedora-fc20-amd64-root.qcow2: dist/Fedora-x86_64-20-20140407-sda.qcow2
	qemu-img convert -O qcow2 $< $@
	qemu-img resize $@ +8G

.PRECIOUS: ubuntu-trusty-amd64-10GB-root.qcow2 fedora-fc20-amd64-root.qcow2

#################################################
## Clone template to root filesystem

%-ubuntu-disk1.qcow2: ubuntu-trusty-amd64-10GB-root.qcow2
	qemu-img create -f qcow2 -b $< $@

%-fc20-disk1.qcow2: fedora-fc20-amd64-root.qcow2
	qemu-img create -f qcow2 -b $< $@


#################################################
## Create user-data image

%-seed.img: %.user-data
	cloud-localds $@ $<


#################################################
# Define vm to libvirt

# Ubuntu
ubuntu-%: %-ubuntu-disk1.qcow2 %-seed.img
	virt-install --nographics --noreboot \
		--name $* \
		--ram 768 \
		--disk path=$<,format=qcow2 \
		--cdrom $*-seed.img \
		--boot=hd --livecd \
		--bridge=br0 -m `python ./mac-generator.py` \
		|| true

fc20-%: %-fc20-disk1.qcow2 %-seed.img
	virt-install --nographics --noreboot \
		--name $* \
		--ram 1024 \
		--disk path=$<,format=qcow2 \
		--cdrom $*-seed.img \
		--boot=hd --livecd \
		--bridge=br0 -m `python ./mac-generator.py` \
		|| true

# Do not remove image files as "intermediate files"
.PRECIOUS: %-ubuntu-disk1.img %-seed.img %-fc20-disk1.qcow2

#################################################
