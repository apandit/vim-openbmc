# OpenBMC vimrc #

Vimrc to help you develop for OpenBMC.

Features:
* Spacing used based on style guide
* Command to run Astyle with appropriate rules (with option for autocmd on save)
* Filtered to openbmc repositories
  * Remote must be github.com/openbmc/\* or
  * Breadcrumb file must exist in pwd or git root: `.openbmc.crumb`

## Install ##

### Pre-reqs ###
Astyle must be installed: `sudo apt-get install astyle`

### Installing ###

If you use vundle:
```
Plugin 'openbmc/vim-openbmc'
```

## Usage ##

The script will only enable the openbmc settings for the following conditions:
* `.openbmc.crumb` in current directory
* `.openbmc.crumb` in root git directory
* `github.com/openbmc` in git remotes

To force openbmc settings on current buffer: `:call UseOpenbmcSettings()`

To always use openbmc settings on all files, add this to your vimrc before
adding the plugin: `let g:openbmc_make_settings_global = 1`

### Options ###

* `g:openbmc_disable_formatonsave`: Disables Astyle formatting on c and cpp
  files on save
* `g:openbmc_make_settings_global`: Applies openbmc settings to all buffers. Not
  recommended except for testing.

## Changelog ##

### 0.1 ###

Initial release with spacing, astyle and repository detection.
