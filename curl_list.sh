#!/bin/bash
# Automatic Downloader
#
# This script will download attempt to download all files given a set of hyperlinks. Immagine this as a list of URLs passed to a cURL.
# This will also attempt to download the file guessing it's origin, however it's not 100% accurate and for fail-safe you must provide an extension. See "How To Use" for details

# How to Use
#
# Usage: ./concat.sh <file_list_path>
#
# The "file_list_path" must be provided as an argument in CLI. 
#
# The structure of the "file list" must be as follows:
# <hyperlink> [extension]
# There must be one hyperlink per line, and optionally an extension.
# 
# Example
# 
# https://placekitten.com/96/139 jpeg
# https://swapi.dev/api/people/1/ json
# https://www.google.com



# file_list_path must be provided as first argument in CLI 
file_list_path="$1"

# Helper variable
now=""
# Helper function to give current time similar to ISO 8601
function time_now(){
    now=$(date +"%F %T.%3N")
    echo $now
}


echo "Begin Process"
mkdir "downloads"
logpath="downloads/logs $(date +"%Y-%M-%d %H-%M-%S").txt"
echo "Start | $(date)" > "${logpath}"

while read -r line; do
    arr=($line)
    echo "[LOG $(time_now)] - Requesting from Url: ${arr[0]} | extension: ${arr[1]}" # Terminal
    echo "[LOG $(time_now)] - Requesting from Url: ${arr[0]} | extension: ${arr[1]}" >> "${logpath}"
    
    # Only errors are to be logged. Silent is used, but errors appear
    curlStatus=$(curl --get -s -S -O "${arr[0]}" --output-dir ./downloads/ 2>&1 > /dev/null);

    if [[ -z $curlStatus ]]; then 
        echo -e "\t[LOG] cURL Worked: $curlStatus" #Terminal
        echo -e "\t[LOG] cURL Worked: $curlStatus" >> "${logpath}"
    else
        # Attempt to force name by using url and force use extension infront of it
        echo -e "\t[LOG] Download Attempt using URL and extension as name" #Terminal

        # CHAT GPT CODE BELOW. WATCH OUT!
        # Remove protocol (http:// or https://) from the beginning of the hyperlink
        hyperlink=${arr[0]}
        trimmed_hyperlink="${hyperlink#*://}"

        # Extract the part up to the top-level domain
        top_domain=$(echo "$trimmed_hyperlink" | awk -F/ '{print $1}')
        # END CHAT GPT CODE

        curlStatus=$(curl --get -s -S "${arr[0]}" -o "${top_domain}.${arr[1]}" --output-dir ./downloads/ 2>&1 > /dev/null);

        if [[ -z $curlStatus ]]; then 
            echo -e "\t[LOG] cURL Worked: $curlStatus" #Terminal
            echo -e "\t[LOG] cURL Worked: $curlStatus" >> "${logpath}"
        else
            echo -e "\t[ERROR] cURL failed. Please download manually at: ${arr[0]}\n\t$curlStatus" # Terminal
            echo -e "\t[ERROR] cURL failed. Please download manually at: ${arr[0]}\n\t$curlStatus" >> "${logpath}"
        fi

        #echo -e "[ERROR] cURL failed.\n$curlStatus" # Terminal
        #echo -e "[ERROR] cURL failed.\n$curlStatus" >> "${logpath}"
    fi
done < "$file_list_path"