#!/bin/bash

# ANSI color codes
pink='\033[0;35m'  # Pink color
red="\e[1;31m"
blue='\e[1;34m'
reset='\033[0m'    # Reset to default color

# Define the ASCII art text
ascii_art="
${pink}    _         _                        _         ____
   / \\  _   _| |_ ___  _ __ ___   __ _| |_ ___  |  _ \\ ___  ___ ___  _ __
  / _ \\| | | | __/ _ \\| '_ \` _ \\ / _\` | __/ _ \\ | |_) / _ \\/ __/ _ \\| '_ \\
 / ___ \\ |_| | || (_) | | | | | | (_| | ||  __/ |  _ <  __/ (_| (_) | | | |
/_/   \\_\\__,_|\\__\\___/|_| |_| |_|\\__,_|\\__\\___| |_| \\_\\___|\\___\\___/|_| |_|

${reset}
"

# Print the ASCII art text
echo -e "$ascii_art"


# Print the banner
echo -e "$banner"

read -p "[+] Domain(ex: google.com): " domain


mkdir -p $domain
mkdir $domain/reports
wordlist_file=$(find . -type f -path "*/auto-recon/wordlist.txt")


echo -e "${blue} [+] Enumerating Subdomain ${reset}"


subdomains(){
    subfinder -d $domain -silent -o $domain/subdomains.txt
    crobat -s $domain | anew $domain/subdomains.txt
    echo -e "${red} [-] Finished subdomain enumerating ${reset}"

}

portScan(){
    echo -e "${blue} [+] Started Portscanning ${reset}"
    cat $domain/subdomains.txt | naabu -ec -o $domain/open-ports.txt
     echo -e "${red} [-] Finished port scanning ${reset}"

}

probe(){
    echo -e "${blue} [+] Finding http web servers ${reset}"
    cat $domain/subdomains.txt | httpx -no-color -random-agent  -o $domain/subdomain_alive.txt
     echo -e "${red} [-] Finished http  probe ${reset}"
}

spider(){
    echo -e "${blue} [+] Spidering $domain ${reset}"
    gospider -s $domain -o $domain/crawled -u web -t 3 -c 5 --js --subs --robots -a -w -r -q --no-redirect
     echo -e "${red} [-] Finished spidering ${reset}"
}

archieve(){
    echo -e "${blue} [+] Finding archeived urls ${reset}"
    gau $domain --blacklist jpg,jpeg,gif,css,js,tif,tiff,png,ttf,woff,woff2,ico,svg,eot  --subs |uro > $domain/gau.txt
     echo -e "${red} [-] Finished  ${reset}"
}

genWordlist(){
    echo -e "${blue} [+] Generating Custom wordlist ${reset}"
    cat $domain/subdomains.txt | unfurl format %S > $domain/custom-wordlist.txt
    cat $domain/gau.txt |unfurl -u paths | sed 's#/#\n#g' |sort -u |anew > $domain/custom-wordlist.txt
     echo -e "${red} [-] Finished genrating custom wordlist ${reset}"

}



screenshot(){
    echo -e "${blue} [+] Started Screenshoting  ${reset}"
   gowitness file -f $domain/subdomain_alive.txt --no-http --no-https  -P $domain/screenshots
    echo -e "${red} [-] Finished screenshots ${reset}"

}


directoryBruteforce(){
  echo -e "${blue} [+] Directory enumerating ${reset}"
  for sub in $(cat ./$domain/subdomain_alive.txt):
    do  
    echo -e "${blue} Fuzzing on:  $sub ${reset}"
    ffuf -w wordlist.txt -u $sub/FUZZ  -ac -mc 200 -s -sa -maxtime-job 120 | tee ./$domain/reports/$(echo  "$sub" | sed 's/\http\:\/\///g' |  sed 's/\https\:\/\///g').txt;
  done;
   echo -e "${red} [-] Finished directory bruteforce ${reset}"
}


start(){
  subdomains
  archieve
  spider
  genWordlist
  portScan
  probe
  screenshot
  directoryBruteforce
}

start

echo -e "${red} [-] [-] [-] Recon on $domain successfully completed [-] [-] [-] ${reset}"
