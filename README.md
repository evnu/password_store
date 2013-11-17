password_store
==============

This is a simple password manager using GPG to encrypt/decrypt a file which stores
passwords in plain text. It is not meant to be very secure, but instead is focused on a
simple interface. This can be useful when configuration files allow to evaluate the
password from a script. With this, one can show configurtion files to friends without
having to cover the passwords with the fingers.


# Usage

1. Create a Password Storage File

    $./store.sh -f passwords.pgp -i evnu -n
                ^                 ^       ^--- create a new file
                |                 |----------- encrypted with this public key id
                |----------------------------- and store it here

2. Store a Password

    $./store.sh -f passwords.pgp -i evnu -s Foo
                                          ^--- store for user Foo

3. Retrieve a Password

    $./store.sh -f passwords.pgp -i evnu -r Foo
                                         ^---- retrieve for user Foo

This will write the password to stdout! (I said this is not meant to be secure.)
