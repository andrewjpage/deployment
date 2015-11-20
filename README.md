Deploy the general repository
=============================

This application does:

1. Checkout a clean copy
2. Build the files
3. Run the tests
4. Build and install the documentation
5. Install the files

Its must be run from a machine with /software mounted on it so that java libraries are accessible, and to avoid permissions issues it needs to be run by pathdb.
    ssh pathdb@pathinfo-test

Usage
-----

    ./deploy.pl -e test

or

    ./deploy.pl --update-checksums -e production
  
To run the application unit tests:

    make test

Dependancies:

  * NaturalDocs
  * Getopt::Long 
  * Net::SCP
  * Git::Repository

