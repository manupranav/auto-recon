   if [[ -z "$GOPATH" ]]; then
        echo "Go lang is required to run this project, Please install."
        PS3="Please select an option : "
        choices=("yes" "no")
        select choice in "${choices[@]}"; do
            case $choice in
            yes)
                echo "Installing Golang"
                wget https://dl.google.com/go/go1.18.5.linux-amd64.tar.gz
                sudo tar -xvf go1.18.5.linux-amd64.tar.gz
                sudo rm -rf /usr/local/go
                sudo mv go /usr/local
                export GOROOT=/usr/local/go
                export GOPATH=$HOME/go
                export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
                echo 'export GOROOT=/usr/local/go' >>~/.bash_profile
                echo 'export GOPATH=$HOME/go' >>~/.bash_profile
                echo 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >>~/.bash_profile
                source ~/.bash_profile
                sleep 1
                break
                ;;
            no)
                echo "Please install go and rerun this script"
                echo "Aborting installation..."
                exit 1
                ;;
            esac
        done
    fi

#create a tools folder in ~/
mkdir ~/tools
cd ~/tools/


echo "Installing crobat"
go install  github.com/cgboal/sonarsearch/cmd/crobat@latest
echo "done"


echo "Installing subfinder"
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo "done"


echo "installing gowitness"
go install github.com/sensepost/gowitness@latest
echo "done"


echo "installing gau"
go install github.com/lc/gau/v2/cmd/gau@latest
echo "done"


echo "installing httpx"
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
echo "done"


echo "installing ffuf"
go install github.com/ffuf/ffuf@latest
echo "done"


echo "installing naabu"
sudo apt install -y libpcap-dev
go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
echo "done"

echo "installing unfurl"
go install github.com/tomnomnom/unfurl@latest
echo "done"



echo "installing uro"
pip3 install uro
echo "done"


echo "installing qsreplace"
go install github.com/tomnomnom/qsreplace@latest
echo "done"

