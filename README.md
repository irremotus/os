# KevEvI OS

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
---------------------------------------------------------------------------------------------

# *WARNING:*

## *Some scripts need sudo to write directly to devices using `dd` and loopback interfaces*

## *None of the scripts ask questions -- they WILL clobber your files*

## *Read and understand the scripts before you use them and before you run `make`*

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
---------------------------------------------------------------------------------------------

### Scripts:

Running `make` runs one or more of these scripts:

 - lo: sets up `disk.img` as a loopback device
 - unlo: tears down the loopback device set up by `lo`
 - createdisk: creates the disk image `disk.img`
 - formatdisk: formats `disk.img` using FAT12
 - copyboot: copies the bootloader `bin/boot` to the disk image
 - copystage2: mounts the filesystem on the disk image and copies the stage 2 loader

### Requirements:

 - nasm
 - qemu

### Building and running:

The following targets are available for `make`:

 - `makedisk`: creates the disk image and copies the files to it
 - `runonly`: runs the emulator with the disk image
 - `full`: compiles and assembles all files
 - `run`: same as `full`, but also runs the emulator
 - `clean`: removes all generated files
