> Note: This project currently only runs on devices running MacOS as it uses the afplay system command to play sound. The project should be able to run on other devices using the VirtualBox virtual machine with the guest OS set to a MacOS release.

> Note: Speakers should be set to the device's internal speakers, as audio behaves inconsistently with earbuds and other bluetooth devices.

## Getting Started

Install dependencies:
```
opam install lwt lwt_ppx domainslib raylib
```

Build and run program:
```
dune build
dune exec bin/main.exe
```