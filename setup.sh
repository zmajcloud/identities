#!/bin/bash

# Configuring identities

ACCOUNT_NAME=$USER

KEY1="$(curl https://raw.githubusercontent.com/zmajcloud/identities/refs/heads/master/accounts/${ACCOUNT_NAME}_1.pub)"
KEY1="$(curl https://raw.githubusercontent.com/zmajcloud/identities/refs/heads/master/accounts/${ACCOUNT_NAME}_2.pub)"

# 2. Verify that both provided files exist and are readable.
if [ -z "$KEY1" ]; then
    echo "Error: Public key file '$KEY1' does not exist or is not readable."
    exit 1
fi

if [ -z "$KEY2" ]; then
    echo "Error: Public key file '$KEY2' does not exist or is not readable."
    exit 1
fi

# 3. Ensure the .ssh directory exists and has the correct permissions (700).
#    This prevents other users on the system from accessing it.
if [ ! -d "$SSH_DIR" ]; then
    echo "Creating directory: $SSH_DIR"
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
fi

# 4. Ensure the authorized_keys file exists and has the correct permissions (600).
#    This prevents other users from reading or writing to it.
if [ ! -f "$AUTHORIZED_KEYS_FILE" ]; then
    echo "Creating file: $AUTHORIZED_KEYS_FILE"
    touch "$AUTHORIZED_KEYS_FILE"
    chmod 600 "$AUTHORIZED_KEYS_FILE"
fi

# 5. Concatenate the contents of the two key files and append them to authorized_keys.
#    Using 'cat' and '>>' ensures each key is added on a new line.
echo "Adding keys to $AUTHORIZED_KEYS_FILE..."
cat "$KEY1" "$KEY2" >> "$AUTHORIZED_KEYS_FILE"

# 6. Add a newline to the end of the file just in case the key files didn't have one.
#    This is good practice to prevent issues with future additions.

echo "✅ Success! Both public keys have been added to your authorized_keys file."