# This function is meant to fix 'Namespaces in Imports field not imported from:' R check note. The note shows up when namespace is used to create package object (not function) or within file marked at '.Rbuildignore' file.

This function is meant to fix 'Namespaces in Imports field not imported
from:' R check note. The note shows up when namespace is used to create
package object (not function) or within file marked at '.Rbuildignore'
file.

## Usage

``` r
missing_deps_note_fix()
```
