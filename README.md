# tmux-running-app

Showing currently running applications in tmux status bar

## Integrations

- `docker`
- `mpd` ([Music Player Daemon](https://www.musicpd.org)) through `nc` (netcat)

## Configurations

Use `#{running_app}` in `status-left` or `status-right` to show a currently
running applications

### Status Format

Please see Components section below in order to add applications to status bar.

Example applications: `{docker}{mpd}`

- `@running-app-status-format`  
Description: An interpolated string with components to show for `#{running_app}`
component  
Default: (No default)  
Values: string with components
- `@running-app-status-left-format`  
Description: An interpolated string with components to show for `#{running_app}`
component on the left status (this will override `@running-app-status-format`)  
Default: (No default)  
Values: string with components
- `@running-app-status-right-format`  
Description: An interpolated string with components to show for `#{running_app}`
component on the right status (this will override `@running-app-status-format`)  
Default: (No default)  
Values: string with components
- `@running-app-status-size`  
Description: A maximum number of icons to show at a given time  
Default: `1`  
Values: number

### Update Interval

- `@running-app-refresh-interval`  
Description: A number of seconds to refresh each of the application icon  
Default: `5`  
Values: number
- `@running-app-rotation-interval`
Description: A number of seconds to rotate between application icons  
Default: `5`  
Values: number

### Applications

#### Docker

- `@running-app-docker-icon`  
Description: An icon to show when Docker is running  
Default: `D`  
Values: string
- `@running-app-docker-icon-starting`  
Description: An icon to show when Docker is starting  
Default: `d`  
Values: string

#### MPD

- `@running-app-mpd-icon`  
Description: An icon to show when MPD is running  
Default: `M`  
Values: string
- `@running-app-mpd-icon-stopped`  
Description: An icon to show when MPD is running but not playing anything  
Default: `m`  
Values: string
- `@running-app-mpd-host`  
Description: An IP address to MPD server  
Default: `127.0.0.1`  
Values: string
- `@running-app-mpd-port`  
Description: A port number of MPD server  
Default: `6600`  
Values: number

### Components

- `{docker}` Docker
- `{mpd}` MPD

You can disable the component based on the platform or architecture by simply
using the following configurations. Please see Detection Note below for platform
and architecture detection

- `@running-app-<app>-<platform>`  
Description: Enable the icon for the specified application on specified platform  
Default: `yes`  
Values: string
- `@running-app-<app>-<architecture>`  
Description: Enable the icon for the specified application on specified architecture  
Default: `yes`  
Values: string
- `@running-app-<app>-<platform>-<architecture>`  
Description: Enable the icon for the specified application on specified platform
with specified architecture  
Default: `yes`  
Values: string

#### Detection Note

Each of the following data will be converted into lowercase, `_/| ` will be
replaced by `-` (dash) and anything but alphanumeric or dash will be truncated

- Platform: Through `uname -s`
- Architecture: Through`uname -m`

## Installation

### Requirements

Please note that this plugin utilize multiple unix tools to deliver its
functionalities (most of these tools should be already installed on most unix systems)

- `sed`
- `grep`
- `cut`
- `awk`
- `uname`
- `wc`

### Using [TPM](https://github.com/tmux-plugins/tpm)

```
set -g @plugin 'spywhere/tmux-running-app'
```

### Manual

Clone the repo

```
$ git clone https://github.com/spywhere/tmux-running-app ~/target/path
```

Then add this line into your `.tmux.conf`

```
run-shell ~/target/path/running-app.tmux
```

Once you reloaded your tmux configuration, all the format strings in the status
bar should be updated automatically.

## Troubleshoots

### Application icons are not updated

First, locate the temporary directory that use for storing caches by running

```
echo "${TMPDIR:-${TMP:-${TEMP:-/tmp}}}"
```

If the temporary directory located above does not exists, try checking on `~/.tmp`.

Then remove all the files under `tmux-running-app-XXX` where `XXX` is any number.

This should remove all the caches which plugin will regenerate itself when needed.

## License

MIT
