#!/bin/bash
# Mount remote machines for live editing in code-server
#
# Setup (inside the code-server container):
# 0. Ensure the container has the correct options (devices, cap_add, security_opt).
# 1. Generate an SSH key and add it to target machines.
# 2. Configure ~/.ssh/config with host aliases (proxmox, vm, rpi). Include IdentityFile!
# 3. Install sshfs.
# 4. Enable `user_allow_other` in /etc/fuse.conf.
# 5. Make the required changes to the script below. 

# Code-server user
CODE_USER="abc"

# Get UID/GID
USER_UID=$(id -u "$CODE_USER")
USER_GID=$(id -g "$CODE_USER")

echo "Using UID=$USER_UID GID=$USER_GID for sshfs mounts"

# Mount points
MOUNTS=(
    "/workspace/proxmox proxmox:/home/<USER>"
    "/workspace/vm vm:/home/<USER>"
    "/workspace/rpi rpi:/home/<USER>"
)

# Create mount points
for mountpoint in /workspace/proxmox /workspace/vm /workspace/rpi; do
    mkdir -p "$mountpoint"
done

# Unmount existing mounts safely
for m in "${MOUNTS[@]}"; do
    MP=$(echo $m | awk '{print $1}')
    if mountpoint -q "$MP"; then
        echo "Unmounting $MP..."
        fusermount -u "$MP" || true
    fi
done

# Mount remote directories
for m in "${MOUNTS[@]}"; do
    MP=$(echo $m | awk '{print $1}')
    REMOTE=$(echo $m | awk '{print $2}')
    echo "Mounting $REMOTE to $MP..."
    sshfs -o allow_other,reconnect,uid=$USER_UID,gid=$USER_GID "$REMOTE" "$MP"
done

echo "All machines mounted!"
ls -la /workspace/