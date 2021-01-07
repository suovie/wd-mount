## WD Mount
Mount an encrypted WD drive on Linux with one command.

### HOW TO RUN:

1. Install ‘sg3_utils’ package for your Linux distro

2. Identify the block drive = /dev/sd?
    `dmesg | grep -i scsi `

3. Run ./mount.sh {path_to_block drive} Eg: <code>./mount.sh /dev/sdb</code>

### Dependency:

- WD-Decrypte submodule from https://github.com/SofianeHamlaoui/WD-Decrypte
    `git submodule add https://github.com/SofianeHamlaoui/WD-Decrypte.git wd-decrypte`

### Reference:
- https://github.com/SifoHamlaoui/WD-Decrypte
- https://youtu.be/Qz51UelzByA

**NOTE: Initialize and update submodule after cloning.**

    `git submodule init`

    `git submodule update`
