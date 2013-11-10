# A Very Simple Password Manager

This is a simple password manager using GPG to encrypt/decrypt a file which stores
passwords in plain text. It is not meant to be very secure, but instead is focused on a
simple interface. This can be useful when configuration files allow to evaluate the
password from a script. With this, one can show configurtion files to friends without
having to cover the passwords with the fingers.


## Usage

1. Create a Password Storage File

    $./store.sh -f passwords.pgp -i evnu -n

2. Store a Password for User Foo

    $./store.sh -f passwords.pgp -i evnu -s Foo

3. Retrieve Password for User Foo

    $./store.sh -f passwords.pgp -i evnu -r Foo

This will write the password to stdout! (I said this is not meant to be secure.)