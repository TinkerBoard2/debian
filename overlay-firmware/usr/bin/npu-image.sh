if [ -e "/sys/devices/platform/f8000000.pcie/pcie_reset_ep" ] ;
then
    echo "upgrading npu pcie image......\n"
    cd /usr/share/npu_fw_pcie/
    npu_upgrade_pcie MiniLoaderAll.bin uboot.img trust.img boot.img
else
    echo "upgrading npu image......\n"
    cd /usr/share/npu_fw/
    npu_upgrade MiniLoaderAll.bin uboot.img trust.img boot.img
fi

sleep 1

echo "update npu image ok\n"
