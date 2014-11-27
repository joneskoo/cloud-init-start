# Download official Ubuntu cloud image
trusty-server-cloudimg-amd64-disk1.img.dist:
	wget -O $@ https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img

# Uncompress and expand VM image
trusty-server-cloudimg-amd64-disk1.img: trusty-server-cloudimg-amd64-disk1.img.dist
	qemu-img convert -O qcow2 $< $@
	qemu-img resize $@ +8G

%-seed.img: %.user-data
	cloud-localds $@ $<

%.img: trusty-server-cloudimg-amd64-disk1.img
	qemu-img create -f qcow2 -b $< $@


.PHONY: clean
clean-%:
	virsh destroy $* || true
	virsh undefine $* || true
	rm -f $*.img $*-seed.img

create-%: %.img %-seed.img
	virt-install --nographics --noreboot \
		--name $* \
		--ram 512 \
		--disk path=$<,format=qcow2 \
		--cdrom $*-seed.img \
		--boot=hd --livecd \
		--bridge=br0 -m `python ./mac-generator.py` \
		|| true

# Do not remove image files as "intermediate files"
.PRECIOUS: %.img %-seed.img
