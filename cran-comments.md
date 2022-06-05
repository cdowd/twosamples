## Test environments
* local macOS (ARM) install, R 4.1.2
* github actions: macOS-latest (r-release), windows-latest (r-release), ubuntu-latest (r-devel), ubuntu-latest (r-release), ubuntu-latest (r-oldrel-1)
* Rhub: Windows Server (r-devel), Ubuntu LTS (r-release), Fedora (r-devel), debian (r-devel)
* Win-builder: Windows (r-unstable)

## R CMD check results
There were no ERRORs or WARNINGs.

There were two NOTES: 
1. Maintainer change 
  - No real change, I am updating my email now that my association with Uchicago has ended, and while I can still use the old email.
2. Only on Windows Server (R-devel): "checking for detritus in temp directory", "found the following files -- 'lastMikTeXException"
  - I have no idea what this is about. It was only an issue on one of 11 testing platforms. I have no ability to test further to diagnose it. It is likely related to the LaTeX in the documents, but without further visibility I'm unable to fix it. 


## Downstream dependencies: revdepcheck results

I checked 2 reverse dependencies, comparing R CMD check results across CRAN and dev versions of this package.

 * I saw 0 new problems
 * I failed to check 0 packages


