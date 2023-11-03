# zWATCHER

zWATCHER is a simple bash script that allows you to monitor a sub/domain or a list of sub/domains or java script files for changes in status codes and content length. If any changes are detected, it will notify you.

#  [![Twitter Follow](https://img.shields.io/twitter/follow/71ntr?style=social)](https://twitter.com/71ntr) [![LinkedIn Connect](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://www.linkedin.com/in/71ntr/)
## Features

- Monitor a single sub/domain or a list of sub/domains for changes.
- Monitor a JS "java script" files for changes.
- Compare HTTP status codes and content length to detect changes.
- You can use any [httpx](https://github.com/projectdiscovery/httpx/releases) tool flag in comparing and changes. 
- Notify the user when changes are detected.
- Specify the scan interval in seconds.
- Save scan results to an output file.

## Prerequisites

- `httpx`: Make sure you have `httpx` installed. You can install it using `go` or use the pre-built binary from the following link: [httpx](https://github.com/projectdiscovery/httpx/releases).
- `notify`: Make sure you have `notify` installed. You can install it using `go` or use the pre-built binary from the following link: [notify](https://github.com/projectdiscovery/notify).

## Usage

```bash
Usage: zwatcher.sh [OPTIONS]

Options:
  -u <domain or URL>           Specify a single domain to scan
  -l <list of domains>         Specify a file containing a list of domains to scan
  -s <interval>                Specify the scan interval in seconds
  -n <notify-id>               Specify the notification ID
  -o <output file>             Specify the output file to save scan results
  -h                           Display this help message
httpx-flags
  -sc                          response status-code
  -cl                          response content-length
  -title                       http title
  you can all httpx flags in zwatcher
Example:
  ./zwatcher.sh -u x.com -s 60 -o out.txt -mc 200 -sc -title -n notifyid
  ./zwatcher.sh -u x.com/script.js -s 60 -o out.txt -mc 200 -sc -title -n notifyid

```

## Examples

1. Monitor a single domain with a scan interval of 60 seconds and save the results to `scanresults.txt`:

```bash
./zwatcher.sh -u example.com -s 60 -o scanresults.txt
```

1. Monitor a list of domains from a file called `domains.txt` with a scan interval of 120 seconds and save the results to `scanresults.txt`:

```bash
./zwatcher.sh -l domains.txt -s 120 -o scanresults.txt
```

### Examples for javascript files

1. Monitor a list of js files in list called `js-urls.txt` with a scan interval of 120 seconds and save the results to `scanresults.txt`:

```bash
./zwatcher.sh -l js-urls.txt -s 120 -o scanresults.txt
```

1. Monitor one js file  `https://hackerone/scripts/admin.js` with a scan interval of 120 seconds and save the results to `scanresults.txt`:

```bash
./zwatcher.sh -u https://hackerone/scripts/admin.js -s 120 -o scanresults.txt
```


## Notifications

zwatcher can notify you when changes are detected. To enable notifications, you need to have the `notify` command installed, which allows sending notifications to the desktop.

The `notify` command can be installed using the following command:

```arduino
go install -v github.com/projectdiscovery/notify/cmd/notify@latest
```

After installing `notify`, you can specify the notification ID using the `-n` flag:

```bash
./zwatcher.sh -u example.com -s 60 -o scanresults.txt -n mynotifyid
```

When changes are detected, zwatcher will send a notification with notify.

## Notes

- If the output file (`o` flag) does not exist, zwatcher will create it when the first scan is completed.
- If you specify a file containing a list of domains (`l` flag), zwatcher will continuously scan each domain in the list with the specified scan interval.

## Disclaimer

This tool is for educational and monitoring purposes only. Use it responsibly and only on domains you have permission to scan. The author is not responsible for any misuse or damage caused by this script.
