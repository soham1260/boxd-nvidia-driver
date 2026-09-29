make modules -j$(nproc)

sudo insmod kernel-open/nvidia.ko

sudo rmmod nvidia_uvm

sudo insmod kernel-open/nvidia-uvm.ko uvm_perf_prefetch_enable=1 
# uvm_perf_fault_replay_policy=1

sudo dmesg -w
