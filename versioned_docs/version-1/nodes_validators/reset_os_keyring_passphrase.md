---
sidebar_position: 7
---

# Changing the Keyring Passphrase for the `os` Keyring Backend

At some point, you will need to create a key on a node in order to execute transactions. This can be easily achieved using the `zigchaind keys` command-line tool.

## Key management operations

Using the `zigchaind keys` command, you can perform various key management operations. For example:

1. Recover an account named `test_user` from a mnemonic, storing the key in the `test` keyring backend, which does not require a passphrase:

   ```bash
   zigchaind keys add test_user --recover --keyring-backend test
   ```

2. Delete `test_user`’s key from the os keyring backend, which uses the operating system's secure storage and does require a passphrase:

   ```bash
   zigchaind keys delete test_user --keyring-backend os
   ```

3. List all keys stored on the default keyring backend, which is `test`:

   ```bash
   zigchaind keys list
   ```

4. Explore additional operations:

   ```bash
   zigchaind keys --help
   ```

## Changing the os keyring backend passphrase

When interacting with the `os` keyring backend for the first time—such as when creating or recovering your first key—you will be prompted to set a keyring passphrase by entering it twice:

```bash
zigchaind keys add test_user --recover --keyring-backend os
> Enter your bip39 mnemonic
several words without meaning…
Enter keyring passphrase (attempt 1/3):
Re-enter keyring passphrase:
```

This passphrase will be stored by the system and required for any future operations using the same keyring backend.

Later on, if you delete the last key stored in the `os` keyring backend, you might want to reset the passphrase—especially if you plan to add keys again in the future.

```bash
zigchaind keys delete test_user --keyring-backend os
Enter keyring passphrase (attempt 1/3):
Key reference will be deleted. Continue? [y/N]: y
Key deleted forever (uh oh!)
```

```bash
zigchaind keys list --keyring-backend os
No records were found in keyring
```

### Steps to reset the keyring passphrase

1. Locate the `keyhash` file under the `'~/.zigchain/` directory:

   ```bash
   ls ~/.zigchain/
   config  data  keyhash  keyring-test  wasm
   ```

1. Rename the `keyhash` file (to effectively reset the “os” backend keyring passphrase):

   ```bash
   mv ~/.zigchain/keyhash ~/.zigchain/keyhash.old
   user@node:~$ ls ~/.zigchain/
   config  data  keyhash.old  keyring-test  wasm
   ```

   Once this is done, the next time you attempt to add a new key using the `os` backend, you will be prompted to set a new keyring passphrase.
