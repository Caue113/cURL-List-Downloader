# Usage

Create a file containing a list of files/executables you want to download placing the URL. Each resource must be separated by a newline. 

A file extension may be put infront of URL separated by a space as a fail-safe when the server doesn't offer a file name via http headers.

```
https://www.someplace.com/downloads/my-executable.exe
https://www.anotherplace.com/static/image-with-no-know-extension png
```

Run the ``curl_list.sh`` with a given path to a file list as parameter

```bash
./curl_list.sh example-file-list
```

All logs and resources will be downloaded into a ./downloads directory in this repo.

# Todo
- reate flags for:
    - path to put downloaded content
    - enable/disable logging
- Make it more resiliant to try requests and special cases, such as:
    - On HTTP 206: ask/force follow the new url
- Better log on error: redirect stderr to logs properly