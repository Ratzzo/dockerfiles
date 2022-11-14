This is the base for containers used to build stuff with my
container_makefile repo. It's essentially an alpine image
with openssh, openrc, and rsync.

Note:
Architecture might change over time, consider using: 
podman manifest inspect <image_name>
if the platform no longer exists to get the platform triplet 
appended to MULTICONTAINER_BUILD_PLATFORMS variable

ie. 
    "architecture": "arm",
    "os": "linux",
    "variant": "v7"

is the same as linux/arm/v7

x86_64 changed to amd64 and it caught me by surprise
