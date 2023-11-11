#!/bin/bash

outputfile="zwatcheroutput.txt"

RESET="\e[0m"
GREEN="\e[1;32m"
RED="\e[1;31m"
YELLOW="\e[1;33m"
CYAN="\e[1;36m"
PLUS="++++++++++"
displaybanner() {
    echo -e "${RED}"
cat << "BANNER"
███████╗██╗    ██╗████████╗ ██████╗██╗  ██╗██████╗
╚══███╔╝██║    ██║╚══██╔══╝██╔════╝██║  ██║██╔══██╗
  ███╔╝ ██║ █╗ ██║   ██║   ██║     ███████║██████╔╝
 ███╔╝  ██║███╗██║   ██║   ██║     ██╔══██║██╔══██╗
███████╗╚███╔███╔╝   ██║   ╚██████╗██║  ██║██║  ██║
╚══════╝ ╚══╝╚══╝    ╚═╝    ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ v2.0
                       BY H1NTR0X01 @71ntr
  SECURITY is a myth. Hacking is not.
BANNER
    echo -e "${RESET}"
}

displayusage() {
    echo -e "${CYAN}Usage: zwatcher.sh [OPTIONS]"
    echo
    echo -e "Options:"
    echo -e "  -u <domain or URL>           Specify a single domain to scan"
    echo -e "  -l <list of domains>         Specify a file containing a list of domains to scan"
    echo -e "  -s <interval>                Specify the scan interval in seconds"
    echo -e "  -n <notify-id>               Specify the notification ID"
    echo -e "  -o <output file>             Specify the output file to save scan results"
    echo -e "  -h                           Display this help message"
    echo -e "httpx-flags"
    echo -e "  -sc                          response status-code"
    echo -e "  -cl                          response content-length"
    echo -e "  -title                       http title"
    echo -e "  you can add httpx flags in zwatcher"
    echo -e "Example:"
    echo -e "${RED}  ./zwatcher.sh -u x.com -s 60 -o out.txt -mc 200 -sc -title"
    echo -e "${RED}  ./zwatcher.sh -u x.com -s 60 -o out.txt -mc 200 -sc -title -n notifyid"
    echo -e "${RED}  ./zwatcher.sh -u x.com/script.js -s 60 -o out.txt -mc 200 -sc -title -n notifyid"
}

runhttpx() {
    if [ -e "$outputfile" ]; then
        echo -e "${GREEN}STARTING SCAN...${RESET}"
    else
        echo -e "${RED}  CREATING : $outputfile${RESET}"
        httpx -silent "${httpx_flags[@]}" -u "$DOMAIN" | tee "$outputfile"
        echo -e "${GREEN}FIRST SCAN COMPLETED & SAVED >> $outputfile${RESET}"
    fi
    httpx -silent "${httpx_flags[@]}" -u "$DOMAIN" > "$(dirname "$outputfile")/.tmp-$(basename "$outputfile")"
}

comparescans() {
    diffoutput=$(cat "$(dirname $outputfile)/.tmp-$(basename $outputfile)" | anew "$outputfile")
    if [ -z "$diffoutput" ]; then
        echo -e "${YELLOW}NOTHING NEW FOUND ${RESET}"
        echo -e "${CYAN}SLEEPING FOR : $SLEEP_INTERVAL SECONDS${RESET}"
    else
        echo -e "${CYAN}NEW CHANGES FOUND...${RESET}"
        echo -e "${GREEN}$PLUS${RESET}"
        echo -e "$diffoutput"
        echo -e "${GREEN}$PLUS${RESET}"

        if [ -n "$notifyid" ]; then
            echo -e "${CYAN}zwatcher found: $diffoutput${RESET}" | notify -id "$notifyid" > /dev/null 2>&1
        else
            echo -e "${YELLOW}SKIPPING NOTIFICATION...${RESET}"
        fi
        echo -e "${CYAN}SLEEPING FOR : $SLEEP_INTERVAL SECONDS${RESET}"
    fi
}

scanfordomainslist() {
    while read -r domain; do
        DOMAIN="$domain"
        while true; do
            runhttpx
            comparescans
            sleep "$SLEEP_INTERVAL"
        done
    done <"$LIST_FILE"
}

if [ $# -eq 0 ]; then
    displaybanner
    displayusage
    exit 1
fi

outputfile_valid="false"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -u) DOMAIN="$2"; shift ;;
        -l)
            LIST_FILE="$2"
            if [ ! -f "$LIST_FILE" ]; then
                echo -e "\n${RED}FILE NOT FOUND! : $LIST_FILE${RESET}" >&2
                exit 1
            fi
            shift
            ;;
        -s) SLEEP_INTERVAL="$2"; shift ;;
        -n) notifyid="$2"; shift ;;
        -o)
            outputfile="$2"
            if [ -z "$outputfile" ]; then
                echo -e "\n${RED}NO OUTPUT FILE SPECIFIED!${RESET}" >&2
                exit 1
            fi
            outputfile_valid="true"
            if [ ! -w "$(dirname "$outputfile")" ]; then
                echo -e "\n${RED}FILE PATH IS WRONG : $outputfile${RESET}" >&2
                exit 1
            fi
            shift
            ;;
        -sc) httpx_flags+=("-sc") ;;
        -cl) httpx_flags+=("-cl") ;;
        -title) httpx_flags+=("-title") ;;
        -mc)
            shift
            mc_arg="$1"
            httpx_flags+=("-mc" "$mc_arg")
            ;;
        -ml)
            shift
            ml_arg="$1"
            httpx_flags+=("-ml" "$ml_arg")
            ;;
        -mlc)
            shift
            mlc_arg="$1"
            httpx_flags+=("-mlc" "$mlc_arg")
            ;;
        -mwc)
            shift
            mwc_arg="$1"
            httpx_flags+=("-mwc" "$mwc_arg")
            ;;
        -mfc)
            shift
            mfc_arg="$1"
            httpx_flags+=("-mfc" "$mfc_arg")
            ;;
        -ms)
            shift
            ms_arg="$1"
            httpx_flags+=("-ms" "$ms_arg")
            ;;
        -mr)
            shift
            mr_arg="$1"
            httpx_flags+=("-mr" "$mr_arg")
            ;;
        -mcdn)
            shift
            mcdn_arg="$1"
            httpx_flags+=("-mcdn" "$mcdn_arg")
            ;;
        -mrt)
            shift
            mrt_arg="$1"
            httpx_flags+=("-mrt" "$mrt_arg")
            ;;
        -mdc)
            shift
            mdc_arg="$1"
            httpx_flags+=("-mdc" "$mdc_arg")
            ;;
        -er)
            shift
            er_arg="$1"
            httpx_flags+=("-er" "$er_arg")
            ;;
        -ep)
            shift
            ep_arg="$1"
            httpx_flags+=("-ep" "$ep_arg")
            ;;
        -fc)
            shift
            fc_arg="$1"
            httpx_flags+=("-fc" "$fc_arg")
            ;;
        -fep) httpx_flags+=("-fep") ;;
        -fl)
            shift
            fl_arg="$1"
            httpx_flags+=("-fl" "$fl_arg")
            ;;
        -flc)
            shift
            flc_arg="$1"
            httpx_flags+=("-flc" "$flc_arg")
            ;;
        -fwc)
            shift
            fwc_arg="$1"
            httpx_flags+=("-fwc" "$fwc_arg")
            ;;
        -ffc)
            shift
            ffc_arg="$1"
            httpx_flags+=("-ffc" "$ffc_arg")
            ;;
        -fs)
            shift
            fs_arg="$1"
            httpx_flags+=("-fs" "$fs_arg")
            ;;
        -fe)
            shift
            fe_arg="$1"
            httpx_flags+=("-fe" "$fe_arg")
            ;;
        -fcdn)
            shift
            fcdn_arg="$1"
            httpx_flags+=("-fcdn" "$fcdn_arg")
            ;;
        -frt)
            shift
            frt_arg="$1"
            httpx_flags+=("-frt" "$frt_arg")
            ;;
        -fdc)
            shift
            fdc_arg="$1"
            httpx_flags+=("-fdc" "$fdc_arg")
            ;;
        -strip) httpx_flags+=("-strip") ;;
        -t)
            shift
            t_arg="$1"
            httpx_flags+=("-t" "$t_arg")
            ;;
        -rl)
            shift
            rl_arg="$1"
            httpx_flags+=("-rl" "$rl_arg")
            ;;
        -rlm)
            shift
            rlm_arg="$1"
            httpx_flags+=("-rlm" "$rlm_arg")
            ;;
        -h)
            displaybanner
            displayusage
            exit 0
            ;;
        \?)
            echo -e "\n${RED}INVALID OPTION -$OPTARG${RESET}" >&2
            displayusage
            exit 1
            ;;
        :)
            echo -e "\n${RED}OPTION -$OPTARG REQUIRES AN ARGUMENT!${RESET}" >&2
            displayusage
            exit 1
            ;;
        *)
            echo -e "\n${RED}FLAG PROVIDED BUT NOT DEFINED: $1${RESET}" >&2
            exit 1
            ;;
    esac
    shift
done

displaybanner

if [ -n "$LIST_FILE" ]; then
    scanfordomainslist
else
    while true; do
        runhttpx
        comparescans
        sleep "$SLEEP_INTERVAL"
    done
fi

displaybanner

if [ -n "$LIST_FILE" ]; then
    scanfordomainslist
else
    while true; do
        runhttpx
        comparescans
        sleep "$SLEEP_INTERVAL"
    done
fi
