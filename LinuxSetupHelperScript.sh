#!/bin/bash

##############################################
#################### Notes ###################
##############################################

# This script automates a series of setup tasks on a Brand New Debian install, typically desktop installs, but can be used on server installs in a pinch
# It installs packages, configures services, sets up security tools, and more.
#   1) Welcomes user and provides some script info
#   2) Installs basic tools I expect on every linux box I use
#   3) access a menu to either pull in and install functions/apps via a markdown file, or setup some special installs / configurations I frequent but are best separate from a "bulk install"

# Important - ensure to run file using "Sudo bash <script location>", script will also need bulk install files in the correct pathing to work

# Function files installs are expecting one string per line and have limited ability to execute anything more complex

# This script does have logging, please see "Vars" for path

##############################################
############## Troubleshooting ###############
##############################################

# uncomment the below line to Enable verbose mode for debugging

#set -x

##############################################
#################### vars ####################
##############################################

#Defaults are set
BaseBulkInstallFileDir="$PWD/HelperScriptFiles/InstallFiles"
ScriptLogFilePath="/var/log/Linux_Setup_Helper_Script.log"

##############################################
################ Pre - Reqs ##################
##############################################

#Ensure script running as Root
echo -e "\e[1mChecking root privileges…\e[0m"
sleep 2

if [[ "$(id -u)" -ne 0 ]]; then
    echo "Not Root Permissions, Exiting...."
    exit 2
fi
sleep 2

#reset colour output
NC='\e[0m'

##############################################
################## Functions #################
##############################################

#Function: Logging
LogMessage() {
    local LogMessageLevel="$1"   # INFO, WARN, ERROR
    local LogMessageText="$2"
    local TimeStamp
    TimeStamp="$(date '+%Y-%m-%d %H:%M:%S')"

    # Colourise console output (optional, works on most terminals)
    case "$LogMessageLevel" in
        INFO)  Colour="\e[32m";;   # green
        WARN)  Colour="\e[33m";;   # yellow
        ERROR) Colour="\e[31m";;   # red
        *)     Colour="\e[0m";;
    esac

    printf "${Colour}[%s] %s${NC}\n" "$TimeStamp" "$LogMessageText"
    printf "[%s] %s\n" "$TimeStamp" "$LogMessageText" >> "$ScriptLogFilePath"
}

#Function: Start Logging
Log_Script_Start() {
#Ensure Log File exist and is clear a new excution is happening by appending information on script start
LogMessage "INFO" "------------------------------------------------------------------"
LogMessage "INFO" "Starting script"
LogMessage "INFO" "$(date '+%Y-%m-%d %H:%M:%S')"
LogMessage "INFO" "------------------------------------------------------------------"
clear
echo "Starting script..."
sleep 2
}

#Function: welcome message to user with info on script
Welcome_Message() {
    clear
    echo 'Welcome to your personal Linux Install Helper!'
    echo
    echo '**IMPORTANT** this script will complete several sensitive privileged actions that could compromise your system.'
    echo 
    echo 'This script is expected to be used on a brand new Debian based install with minium modifications.'
    echo 'The goal would be to automate as much as the setup as possible given my knowledge at this time, as well as'
    echo '  having much of the process in one place to ensure not overlooked and standardized.'
    echo 
    echo 'While ansible, terraform and packer, might be used in homelab, I love to have a setup helper for desktops'
    echo '  or in the event of needing to setup a server quickly.'
    echo '================================================================================================================='
    echo ' [exit by hitting ctrl+c]'
    sleep 16
}

#Function: This function setups some core basic functionality I expect explicitly on all linux systems I use
Baseline() {
    clear
    echo "checking core system functionality requirements"
    sleep 2
    Install_All_Updates
    Install_Vim
    Install_SUDO
    Install_Curl
}

#Function: ensure system and packages all fully updated
Install_All_Updates() {
    echo "Updating and upgrading the system..."
    sleep 1.2
    apt update -y && apt upgrade -y
    apt dist-upgrade -y
    apt autoremove -y
    echo "============================="
    LogMessage "WARN" "updates attempted, status unclear."
    echo "updates complete."
    sleep 1.2
    clear
}

#Function: install Vim
Install_Vim() {
    echo "Installing Vim..."
    sleep 1.2
    apt install -y vim
    echo "============================="
    LogMessage "WARN" "Vim install attempted, status unclear."
    echo "Vim install complete."
    sleep 1.2
    clear
}

#Function: install SUDO
Install_SUDO() {
    echo "Installing SUDO..."
    sleep 1.2
    apt install -y sudo
    echo "============================="
    LogMessage "WARN" "SUDO install attempted, status unclear."
    echo "Sudo install complete."
    sleep 1.2
    clear
}

#Function: install Curl
Install_Curl() {
    echo "Installing curl..."
    sleep 2
    apt install -y curl
    echo "============================="
    LogMessage "WARN" "Curl install attempted, status unclear."
    echo "Curl install complete."
    sleep 5
    clear
}

# Main function to handle user input and execute selected options
Main_Menu() {
    while true; do
        Display_Menu
        read -p "Enter your selection(s): " user_input

        # Convert user input into an array
        options=($user_input)

        # Iterate over the options and call respective functions
        for option in "${options[@]}"; do

            #Make sure option is a number
            if ! [[ "$option" =~ ^[0-9]+$ ]]; then
                echo "Invalid input: '$option' is not a number."
                continue
            fi

            case $option in
                1) Install_Base_Security ;;
                2) Install_Functions_From_File_Menu ;;
                3) Lockdown_SSH ;;
                4) Install_Docker_Portainer ;;
                5) Setup_NFS_Share ;;
                6) Install_Powertop ;;
                7) Install_Wazuh_Agent ;;
                8) Add_Users_Groups ;;
                9) Add_User_To_SUDO ;;
                10) Install_Jellyfin ;;
                11) Install_Intel_Drivers ;;
                12) Install_Nvidia_Drivers ;;
                13) Install_Qemu_Guest_Agent ;;
                14) Setup_Template_For_PVE ;;
                15) echo "Exiting..."; Closeout_System ;;
                *) echo "Invalid option: $option" ;;
            esac
        done

        # Ask the user if they want to return to the menu
        read -p "Would you like to return to the menu? (y/n): " return_choice
        if [[ "$return_choice" != "y" && "$return_choice" != "Y" ]]; then
            echo "Goodbye!"
            Closeout_System
        fi

    done
}

# Function: pretty display menu for end user
Display_Menu() {
    clear
    echo "================================"
    echo "  Welcome to the function menu"
    echo "================================"
    echo "1) Install and Configure Base Security Standards"
    echo "2) Install Bulk Functions From File (Optional Requirement - Docker)"
    echo "3) Lockdown/Disable SSH"
    echo "4) Install and config Docker with option for Portainer (Requirement - UFW)"
    echo "5) Install and setup NFS share client (Requirement - UFW)"
    echo "6) install and run Powertops"
    echo "7) install and configure Wazuh Agent (Requirement - UFW)"
    echo "8) Add User and Groups"
    echo "9) Add User to SUDO"
    echo "10) JellyFin Media Server Install for Linux (Requirement - UFW)"
    echo "11) Intel GPU Driver Install"
    echo "12) Nvidia GPU Driver Install"
    echo "13) Install QEMU guest agent (Requirement - VM Env)"
    echo "14) "Template" Machine for proxmox (Requirement - VM Env)"
    echo "15) Exit"
    echo "================================"
    echo "Please select one or more options (e.g., 1 3 5): "
}

# Function: install my standards for a baseline security posture                                                        
Install_Base_Security(){
    clear
    Install_AppArmor
    Install_UFW #This needs to happen before Crowdsec!
    Install_Crowdsec
    Install_Unattended_Upgrades
    Install_ClamAV
}

#Function: install apparmor (should already be installed, nothing configured beyond basic)
Install_AppArmor() {
    # AppArmor
    echo "Ensuring AppArmor is installed..."
    sleep 2
    apt install -y apparmor apparmor-utils
    systemctl enable apparmor
    systemctl start apparmor
    echo "============================="
    echo "AppArmor install complete."
    sleep 5
    clear
}

#Function: installed UFW and configure
Install_UFW() {
    # UFW
    echo "Installing UFW..."
    sleep 2
    apt install -y ufw
    ufw default deny incoming
    ufw default deny outgoing
    ufw reject 22 #ssh
    ufw allow out 443/tcp #https, used for updates
    ufw allow out 53 #dns
    ufw allow out 80/tcp #http, used for updates
    ufw allow out 123/udp #ntp

    read -p "Would you like to add any custom (incoming or outgoing) ports? (y/n): " ConfirmedPortCustomAddChoice
    if [[ $ConfirmedPortCustomAddChoice == "y" || $ConfirmedPortCustomAddChoice == "Y" ]]; then
        UFWPortAddLoop=true
        while [ $UFWPortAddLoop == true ]; do

            echo "What (incoming) port would you like to add?"
            echo "please only type in one port, prompt will loop"
            read -p "(port or [spacebar]): " PortCustomAddChoice

            ufw allow in $PortCustomAddChoice

            read -p "Would you like to add any more custom (incoming) ports? (y/n): " MorePortCustomAddChoice

            if [[ $MorePortCustomAddChoice == "n" || $MorePortCustomAddChoice == "N" ]]; then
                echo "Not adding any additional (incoming) custom ports"
                UFWPortAddLoop=false
            fi
        done

        UFWPortAddLoop=true
        while [ $UFWPortAddLoop == true ]; do

            echo "What (outgoing) port would you like to add?"
            echo "please only type in one port, prompt will loop"
            read -p "(port or [spacebar]): " PortCustomAddChoice

            ufw allow out $PortCustomAddChoice

            read -p "Would you like to add any more custom (outgoing) ports? (y/n): " MorePortCustomAddChoice

            if [[ $MorePortCustomAddChoice == "n" || $MorePortCustomAddChoice == "N" ]]; then
                echo "Not adding any additional (outgoing) custom ports"
                UFWPortAddLoop=false
            fi
        done
    fi

    ufw reload
    ufw enable
    clear
    echo "============================="
    ufw status
    echo "============================="
    echo "UFW install and basic config complete."
    sleep 15
    clear
}

#Function: for installing Crowdsec to act as bad ip bouncer
Install_Crowdsec() {
    # Crowdsec
    echo "Installing Crowdsec..."
    sleep 2

    #setup repo
    curl -s https://install.crowdsec.net | bash

    #install sec engine
    apt install -y crowdsec

    # Install CrowdSec's firewall integration to block IPs (only if UFW or firewalld is installed)
    apt install -y crowdsec-firewall-bouncer-iptables
    echo "please capture API key, you will not be able to get this again"
    sleep 20
    read -p "Press any key to continue... " -n1 -s

    # Turn on logs for UFW for crowdsec to work in ideal state
    ufw logging on

    #enable and start sec engine
    systemctl enable crowdsec
    systemctl start crowdsec

    echo "============================="
    echo "Crowdsec basic package installed, and firewall bouncer."
    echo "Please install additional bouncers as you need, some of these can be facilitated via integrations on the service side."
    echo "IMPORTANT - Crowdsec Not enrolled with CrowdSec Console"
    echo "Note - this is not required"
    sleep 5
    clear
}

#Function: install and do intial scan for baseline of system for ClammAVd
Install_ClamAV() {
    #ClamAV
    echo "Installing ClamAV..."
    sleep 2
    apt-get install -y clamav-daemon

    #Enabling and starting service
    systemctl enable clamav-daemon
    systemctl start clamav-daemon

    #ensure service starts
    sleep 60

    #make wuarantine space
    mkdir /root/quarantine

    # Custom add cron runtime 
    if [[ $CustomizeSettings == "y" || $CustomizeSettings == "Y" ]]; then
        read -p "What time would you like to run the clamAV scan at everyday? " CronTimeClamAVChoice
        CronTimeClamAV=$CronTimeClamAVChoice
        echo "Creating cron to run at $CronTimeClamAV"
    else
        CronTimeClamAV=1
    fi

    # Schedule cron job for full system scan every Sunday at 1 AM
    echo "0 $CronTimeClamAV * * 0 root /usr/bin/clamdscan --fdpass --log=/var/log/clamav/clamdscan.log --move=/root/quarantine /" | tee /etc/cron.d/clamdscan

    # Commenting Out from scan several system default directories that contain false positives
    printf "ExcludePath ^/proc\nExcludePath ^/sys\nExcludePath ^/run\nExcludePath ^/dev\nExcludePath ^/snap\nExcludePath ^/root/quarantine\n" | tee -a /etc/clamav/clamd.conf

    #restart service
    systemctl restart clamav-daemon

    echo "============================="
    echo "Running Intial ClamAV Baseline scan."

    # Run initial scan to form baseline
    /usr/bin/clamdscan --fdpass --log=/var/log/clamav/clamdscan.log --move=/root/quarantine /

    echo "============================="
    echo "ClamAV install complete."
    sleep 5
    clear
}

# Function: call which type of bulk install you would like to complete, currently supports debian package manager, docker images or flathub
Install_Functions_From_File_Menu() {
    clear
    echo "=========================================="
    echo "   Select the installation method"
    echo "=========================================="
    echo "1) apt      – Debian/Ubuntu package manager"
    echo "2) flatpak – Flathub universal packages"
    echo "3) docker   – Pull container images"
    echo
    echo "Enter the number of your choice, or press ENTER for the default (apt)."
    echo

    while true; do
        read -rp "Choice [1/2/3]: " MenuChoice
        case "${MenuChoice}" in
            1|"")   # apt selected (empty input defaults to apt)
                InstallType="apt"
                LogMessage "INFO" "User selected apt as the install method."
                # Build the file path for apt – you can replace the filename if you keep a separate apt list
                FunctionFilePath="${BaseBulkInstallFileDir}/PackageInstalls.md"
                break
                ;;
            2)
                InstallType="flatpak"
                echo "calling install for flatpak and setup flathub..."
                sleep 1.2
                Install_Flathub
                LogMessage "INFO" "User selected flatpak as the install method."
                # Build the file path for apt – you can replace the filename if you keep a separate apt list
                FunctionFilePath="${BaseBulkInstallFileDir}/FlatpakInstalls.md"
                break
                ;;
            3)
                InstallType="docker"
                echo "calling install for docker..."
                sleep 1.2
                Install_Docker_Portainer
                LogMessage "INFO" "User selected docker as the install method."
                # Build the file path for apt – you can replace the filename if you keep a separate apt list
                FunctionFilePath="${BaseBulkInstallFileDir}/DockerInstalls.md"
                break
                ;;
            *)
                LogMessage "WARN" "Invalid menu selection: $MenuChoice"
                echo "Please enter 1 for apt, 2 for flatpak, or 3 for docker."
                ;;
        esac
    done

    # Confirm the choice before proceeding
    echo
    echo "You have chosen: ${InstallType^^}"
    read -rp "Proceed with this install method? (y/n): " ConfirmChoice
    case "${ConfirmChoice,,}" in
        y|yes)
            LogMessage "INFO" "Proceeding with $InstallType installation."
            ;;
        *)
            LogMessage "INFO" "User aborted after menu selection."
            echo "Exiting as requested."
            return 0
            ;;
    esac

    #Call the main installer function now that InstallType is selected
    Install_Functions_From_File
}

# Function: Setup FlatHub for flatpak installs
Install_Flathub() {
    echo "============================="
    echo "Installing Flatpak..."
    sleep 1.2
    apt install flatpak

    echo "============================="
    echo "Flatpak is installed"
    sleep 1.2

    echo "Setting up Flathub repository..."
    sleep 1.2
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

    echo "============================="
    echo "Flathub repository is setup for flatpak installs."
    sleep 1.2
    echo "============================="
}

Install_Functions_From_File() {
    # Validate InstallType
    case "${InstallType,,}" in
        apt|flatpak|docker) ;;               # supported
        *)
            LogMessage "ERROR" "Unsupported InstallType: \"$InstallType\". Use \"apt\", \"flatpak\" or \"docker\"."
            return 1
            ;;
    esac

    # Load the markdown file into an array (ignore blanks, trim spaces)
    if [[ ! -f "$FunctionFilePath" ]]; then
        LogMessage "ERROR" "File not found: $FunctionFilePath"
        return 1
    fi

    mapfile -t RawLines <"$FunctionFilePath"
    declare -a ItemsArray=()
    for Line in "${RawLines[@]}"; do
        # Trim leading/trailing whitespace
        Line="${Line#"${Line%%[![:space:]]*}"}"
        Line="${Line%"${Line##*[![:space:]]}"}"
        [[ -z "$Line" ]] && continue
        ItemsArray+=("$Line")
    done

    TotalItems=${#ItemsArray[@]}
    if (( TotalItems == 0 )); then
        LogMessage "WARN" "No install entries found in $FunctionFilePath"
        return 0
    fi

    # Pre‑flight validation: pretty two‑column bullet list
    clear
    echo "=== PRE‑FLIGHT VALIDATION ==="
    echo "File          : $FunctionFilePath"
    echo "Install method: ${InstallType^^}"
    echo "Entries found : $TotalItems"
    echo

    TermWidth=$(tput cols)
    ColumnWidth=$(( TermWidth / 2 ))
    (( ColumnWidth < 30 )) && ColumnWidth=30

    for (( i=0; i<TotalItems; i++ )); do
        LeftIdx=$i
        LeftItem="${ItemsArray[$LeftIdx]}"
        printf " • %-*s" "$ColumnWidth" "$LeftItem"

        RightIdx=$(( i + TotalItems/2 + TotalItems%2 ))
        if (( RightIdx < TotalItems )); then
            RightItem="${ItemsArray[$RightIdx]}"
            printf " • %s" "$RightItem"
        fi
        echo
    done

    echo
    echo "Review the list above."
    echo "Type 'confirm', 'c' or 'confirmed' to continue,"
    echo "or type 'exit' to abort, or 'manual' for step‑by‑step mode."
    echo

    # Confirmation loop
    while true; do
        read -rp "Your choice [confirm/exit/manual]: " UserChoice
        case "${UserChoice,,}" in
            confirm|c|confirmed)
                Mode="Auto"
                break
                ;;
            exit)
                LogMessage "INFO" "User chose to exit before installation."
                echo "Exiting as requested."
                return 0
                ;;
            manual)
                Mode="Manual"
                break
                ;;
            *)
                LogMessage "WARN" "Invalid confirmation input: $UserChoice"
                echo "Please type 'confirm', 'exit' or 'manual'."
                ;;
        esac
    done

    # Begin installation
    echo "Starting to install......"
    LogMessage "INFO" "Installation started (Mode=$Mode, InstallType=$InstallType)."
    sleep 5

    InstalledCount=0
    SkippedCount=0
    FailedCount=0

    for (( Idx=0; Idx<TotalItems; Idx++ )); do
        CurrentItem="${ItemsArray[$Idx]}"
        clear
        echo "🔧 Installing [$((Idx+1))/$TotalItems]: $CurrentItem"
        LogMessage "INFO" "Attempting install of \"$CurrentItem\" (index $((Idx+1)))"

        # Manual mode prompt
        if [[ "$Mode" == "Manual" ]]; then
            while true; do
                read -rp "Install \"$CurrentItem\"? (y=install, s=skip, e=exit): " Action
                case "${Action,,}" in
                    y|yes|install)
                        SelectedAction="Install"
                        break
                        ;;
                    s|skip)
                        SelectedAction="Skip"
                        break
                        ;;
                    e|exit)
                        LogMessage "INFO" "User exited during manual install (item=\"$CurrentItem\")."
                        echo "Exiting as requested."
                        # final summary
                        echo ""
                        echo "=== INSTALL SUMMARY ==="
                        echo "Installed : $InstalledCount"
                        echo "Skipped   : $SkippedCount"
                        echo "Failed    : $FailedCount"
                        echo "Log file  : $ScriptLogFilePath"
                        return 0
                        ;;
                    *)
                        LogMessage "WARN" "Unexpected manual response: $Action"
                        echo "Please answer with 'y', 's' or 'e'."
                        ;;
                esac
            done
        else
            SelectedAction="Install"
        fi

        if [[ "$SelectedAction" == "Skip" ]]; then
            echo "Skipping $CurrentItem"
            LogMessage "INFO" "SKIPPED – $CurrentItem"
            ((SkippedCount++))
            sleep 1.5
            continue
        fi

        # Perform the bulk install
        case "${InstallType,,}" in
            apt)
                if apt-get install -y "$CurrentItem" >/dev/null 2>&1; then
                    echo "Successfully installed $CurrentItem (apt)"
                    LogMessage "INFO" "SUCCESS – apt – $CurrentItem"
                    ((InstalledCount++))
                else
                    ErrMsg=$(apt-get install -y "$CurrentItem" 2>&1 | head -n 3)
                    echo "Failed to install $CurrentItem (apt)"
                    echo "    Error: $ErrMsg"
                    LogMessage "ERROR" "FAILURE – apt – $CurrentItem – $ErrMsg"
                    ((FailedCount++))
                fi
                ;;

            flatpak)
                if flatpak install -y flathub "$CurrentItem" >/dev/null 2>&1; then
                    echo "Successfully installed $CurrentItem (flatpak)"
                    LogMessage "INFO" "SUCCESS – flatpak – $CurrentItem"
                    ((InstalledCount++))
                else
                    ErrMsg=$(flatpak install -y flathub "$CurrentItem" 2>&1 | head -n 3)
                    echo "Failed to install $CurrentItem (flatpak)"
                    echo "    Error: $ErrMsg"
                    LogMessage "ERROR" "FAILURE – flatpak – $CurrentItem – $ErrMsg"
                    ((FailedCount++))
                fi
                ;;

            docker)
                if docker pull "$CurrentItem" >/dev/null 2>&1; then
                    echo "Successfully pulled $CurrentItem (docker)"
                    LogMessage "INFO" "SUCCESS – docker – $CurrentItem"
                    ((InstalledCount++))
                else
                    ErrMsg=$(docker pull "$CurrentItem" 2>&1 | head -n 3)
                    echo "Failed to pull $CurrentItem (docker)"
                    echo "    Error: $ErrMsg"
                    LogMessage "ERROR" "FAILURE – docker – $CurrentItem – $ErrMsg"
                    ((FailedCount++))
                fi
                ;;
        esac

        sleep 1.5
    done

    # Post‑install cleanup (apt only)
    if [[ "${InstallType,,}" == "apt" ]]; then
        echo "Running apt clean & autoremove..."
        LogMessage "INFO" "Running 'apt clean && apt autoremove -y'"
        apt-get clean >/dev/null 2>&1
        apt-get autoremove -y >/dev/null 2>&1
        LogMessage "INFO" "APT cleanup completed."
    else
        echo "No additional cleanup required for ${InstallType^^}."
        LogMessage "INFO" "${InstallType^^} mode – skipped apt cleanup."
    fi

    # Final summary (terminal + log)
    echo ""
    echo "=== FINAL SUMMARY ==="
    echo "Installed : $InstalledCount"
    echo "Skipped   : $SkippedCount"
    echo "Failed    : $FailedCount"
    echo "Log file  : $ScriptLogFilePath"
    LogMessage "INFO" "INSTALLATION SUMMARY – Installed=$InstalledCount, Skipped=$SkippedCount, Failed=$FailedCount"
    LogMessage "INFO" "Log file location: $ScriptLogFilePath"
}


# Function: lockdown ssh
Lockdown_SSH() {
    clear
    echo "locking down ssh via UFW, files and service..."
    sleep 1.2
    # shutdown ssh service
    systemctl stop ssh
    systemctl disable ssh
    systemctl sta!= true =tus ssh
    ## Remove host keys
    rm /etc/ssh/ssh_host_*
    ## block ufw port
    ufw reject ssh
    ufw reject 22
    echo "============================="
    clear
}

# Function: Ask if the user wants to install Docker and Portainer
Install_Docker_Portainer() {
    clear
    # Install Docker
    echo "Installing docker using community script method..."
    sleep 1.2
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl enable docker
    systemctl start docker

    # Remove Docker sh
    rm get-docker.sh

    echo "============================="
    echo "Docker install complete."
    sleep 1.2
    echo "============================="

    echo "Would you like to install Portainer?"
    read -p "please type "yes" to continue: " choice
    if [[ "$choice" == "yes" ]]; then
            ##creating portainer data volume
            docker volume create portainer_data

            # Change Portainer default port to custom port
            read -p "What port would you like to run HTTPS Portainer on? (default is 9443): " PortainerHTTPSPortChoice
            echo "Creating a custom Portainer container on port $PortainerHTTPSPortChoice..."
            read -p "What name would you like to run this Portainer instance under?: " PortainerNameChoice
            echo "Creating a custom Portainer container on port $PortainerNameChoice..."

            docker run -d -p $PortainerHTTPSPortChoice:9443 --name $PortainerNameChoice --restart always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

            # Allow Portainer through UFW
            ufw allow $PortainerHTTPPortChoice
            ufw allow $PortainerHTTPSPortChoice

            echo "============================="
            echo "Portainer install complete."
            sleep 1.2
    fi
    clear
}

# Function: Install Unattended Upgrades
Install_Unattended_Upgrades() {
    echo "Unattended upgrades is best for servers, as its expected to run outside of normal hours and reboot."
    sleep 2
    echo "Installing unattended-upgrades..."
    sleep 1.2
    apt install -y unattended-upgrades

    # Configure unattended-upgrades
    echo "Enabling unattended upgrades..."
    sleep 1.2
    dpkg-reconfigure --priority=low unattended-upgrades

    # Enable and start the service
    systemctl enable unattended-upgrades
    systemctl start unattended-upgrades

    # Service will not only do base updates for security related patches

    # Note - typically enabled, but sometimes 20auto-upgrades will not have either item enabled via boolen values, these need to be set to '1' (enabled)

    # copy file and make it a higher priority, this does 2 things. 1) ensure with updates to unattended update the base config file does not change itself 2) ensure my config is the one that is actioned on.
    cp /etc/apt/apt.conf.d/50unattended-upgrades /etc/apt/apt.conf.d/90unattended-upgrades

    # Add lines of configurations to unattened-upgrades, normally you would uncomment these, however we will just append them which works as well.
    # Remove old unsued packages and dependencies (as part of, or existed before, unattended upgrades ran upgrades)
    sudo echo 'Unattended-Upgrade::Remove-Unused-Kernel-Packages "true";' >> /etc/apt/apt.conf.d/90unattended-upgrades
    sudo echo 'Unattended-Upgrade::Remove-New-Unused-Dependencies "true";' >> /etc/apt/apt.conf.d/90unattended-upgrades
    sudo echo 'Unattended-Upgrade::Remove-Unused-Dependencies "true";' >> /etc/apt/apt.conf.d/90unattended-upgrades
    # Will self reboot system if reboot is required for update (checked by if file exist - /var/run/reboot-required)
    sudoecho 'Unattended-Upgrade::Automatic-Reboot "false";' >> /etc/apt/apt.conf.d/90unattended-upgrades
    # Will self reboot system even if a user is logged in
    sudo echo 'Unattended-Upgrade::Automatic-Reboot-WithUsers "true";' >> /etc/apt/apt.conf.d/90unattended-upgrades
    # schedule time task for when to "REBOOT", please note that some other defaults for times happen between 1am-3am and 6am-7am local time
    sudo echo 'Unattended-Upgrade::Automatic-Reboot-Time "07:30";' >> /etc/apt/apt.conf.d/90unattended-upgrades

    echo "Running dry-run install of unattended upgrades"
    sleep 1.2
    unattended-upgrade --dry-run --debug

    echo "============================="
    echo "Unattended-Upgrades install complete."
    echo "Unattended-Upgrades will run between default time of 6am-7am and reboot at 7:30am local time"
    sleep 10
    clear
}

# Function: Setup NFS Share Mount and fstab
Setup_NFS_Share() {
    clear
    echo "Setting up NFS shares using NFSv3..."

    # Install NFS client if not installed
    apt install -y nfs-common

    # Custom add NFS mount to fstab
    NFSAddLoop=true
    while [ $NFSAddLoop == true ]; do
        echo "============================="
        echo "please only type in one option at a time, the prompts will loop"
        read -p "Enter NFS server IP address: " nfs_ip
        read -p "Enter the shared directory path: " shared_path
        read -p "Enter the mount point on this server: " mount_point

        echo "Ensuring mount point exist for "$mount_point"..."
        sleep 1.2

        # Create the mount point directory
        mkdir -p "$mount_point"

        echo "Adding NFS share to fstab..."
        sleep 1.2

        # Add the NFS mount to fstab
        echo "$nfs_ip:$shared_path "$mount_point" nfs defaults 0 0" >> /etc/fstab

        read -p "Would you like to add any more NFS mounts to fstab? (y/n): " MoreNFSAddChoice

        if [[ $MoreNFSAddChoice == "n" || $MoreNFSAddChoice == "N" ]]; then
            echo "Not adding any additional mounts"
            NFSAddLoop=false
        fi

    done

    echo "============================="
    echo "Allowing out default NFSv3 port..."
    sleep 1.2

    # Allow out the port
    ufw allow out 2049

    echo "============================="
    echo "Attempting to mount shares..."
    sleep 1.2

    # Mount all shares in fstab
    mount -av

    echo "============================="
    echo "nfs setup complete."
    sleep 1.2
    clear
}

# Function: install and offer to run powertops
Install_Powertop() {
    clear
    # Install powertop
    echo "Installing powertop..."
    apt install -y powertop

    # Check if installation was successful
    if [ $? -eq 0 ]; then
        echo "powertop installation completed successfully."
    else
        echo "Installation failed. Please check your package manager configuration."
        exit 1
    fi

    # Ask user if they want to run the initial setup
    read -p "Do you want to run the initial setup for powertop? (y/n): " setup_choice

    # Run powertop setup if user chooses 'y'
    if [[ $setup_choice == "y" || $setup_choice == "Y" ]]; then
    echo "Running powertop's initial setup..."
    sleep 2

    # Run powertop in calibration mode for initial setup (this requires root)
    powertop --calibrate

    else
        echo "Skipping powertop initial setup."
    fi

    echo "============================="
    echo "Powertop install and config complete."
    sleep 5
    clear
}

# Function: Install and Configure Wazuh Agent
Install_Wazuh_Agent() {
    clear
    echo "Installing and configuring Wazuh Agent..."
    echo "please ensure firewall rules are allowed at all levels, you have 2 minutes, or cancel this script and retry"
    sleep 120
    apt install -y gnupg2
    curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
    echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
    apt-get update

    # Configure Wazuh agent to connect to remote manager
    read -p "Enter Wazuh Manager IP address: " wazuh_manager_ip
    WAZUH_MANAGER="$wazuh_manager_ip" apt-get install wazuh-agent

    # Allow Wazuh Manager through firewall
    ufw allow out 1514
    ufw allow out 1515

    # Enable and start Wazuh agent
    systemctl daemon-reload
    systemctl enable wazuh-agent
    systemctl start wazuh-agent

    echo "letting Wazuh agent register, then cleaning up firewall..."
    sleep 90
    ufw reject 1515

    echo "============================="
    echo "Wazuh Agent install complete."
    sleep 1.2
    clear
}

# Function: Add Users and Groups
Add_Users_Groups() {
    clear
    read -p "Would you like to setup a group and user? (y/n): " choice
    if [[ "$choice" == "y" ]]; then
        echo "Adding users and groups..."
        read -p "Enter the group name to create: " group_name
        groupadd "$group_name"

        read -p "Enter the username to create: " username
        useradd -m -g "$group_name" "$username"

        read -p "Enter GID for the group: " gid
        groupmod -g "$gid" "$group_name"

        read -p "Enter UID for the user: " uid
        usermod -u "$uid" "$username"
        echo "============================="
        echo "nfs install complete."
        sleep 1.2
    else
        echo "Exiting function..."
        sleep 1.2
    fi
    clear
}

# Function: Add custom user to sudo group
Add_User_To_SUDO() {
    clear

    #ask for a username, validate, add to sudo, loop back
    while true; do
        clear
        echo -e "\e[1mAdd a user to the sudo group\e[0m"
        read -rp "Enter the username to grant sudo rights (or press ENTER to quit): " UserName

        # Allow the user to abort by hitting ENTER with no input
        [[ -z "$UserName" ]] && { LogMessage "WARN" "User aborted the operation."; break; }

        # Validate that the user exists on the system
        if ! id "$UserName" >/dev/null 2>&1; then
            LogMessage "WARN" "User \"$UserName\" does not exist."
            echo -e "\e[33mUser \"$UserName\" does not exist. Please try again.\e[0m"
            sleep 1.5
            continue
        fi
        LogMessage "INFO" "User \"$UserName\" exists – proceeding."

        # Warn about the security implications and confirm
        clear
        cat <<'EOF'
    Adding a user to the sudo group gives that user full administrative
    privileges on this machine. They will be able to run any command
    as root, which can affect system stability, security, and privacy.
    Only add trusted users!
EOF
        read -rp "Do you really want to add \"$UserName\" to the sudo group? (confirm): " Confirmation
        [[ "$Confirmation" != [confirm]* ]] && {
            LogMessage "WARN" "User chose not to add \"$UserName\" to sudo."
            echo "Skipping \"$UserName\"."
            sleep 1.5
            continue
        }

        # Add the user to the sudo group
        clear
        echo -e "\e[1mAdding \"$UserName\" to the sudo group…\e[0m"
        sleep 1.5

        if usermod -aG sudo "$UserName" 2>>"$ScriptLogFilePath"; then
            LogMessage "INFO" "Successfully added \"$UserName\" to sudo group."
            echo -e "\e[32mSuccess: $UserName is now a member of sudo.\e[0m"
        else
            ErrorDetail=$(tail -n1 "$ScriptLogFilePath")
            LogMessage "ERROR" "Failed to add \"$UserName\" to sudo. Error: $ErrorDetail"
            echo -e "\e[31mError adding $UserName to sudo. Check the log for details.\e[0m"
        fi
        sleep 1.5

        # Ask to add another user
        read -rp "Would you like to add another user? (y/N): " AddAnother
        [[ "$AddAnother" != [Yy]* ]] && {
            LogMessage "INFO" "User finished adding sudo members."
            break
        }
    done

    clear
    LogMessage "INFO" "Add_User_To_SUDO function exited."
}

# Function: Install Linux type Jellyfin media server
Install_Jellyfin() {
    clear

    # the best way is to connect to the jellyfin repo, so you can easliy stay up to date
    # If using Debian, I highly recommend using the repo tool "extrepo"
    # install extrepo
    echo "Installing and configuring Extrepo for Jellyfin install..."
    sleep 1.2
    apt install -y extrepo

    #enable yourself to download/update Jellyfin via extrepo
    extrepo enable jellyfin

    #update system to pull in the jellyfin repos you have enabled
    apt update && apt upgrade

    # install full package of Jellyfin
    echo "Installing Jellyfin Media Server..."
    sleep 1.2

    apt install -y jellyfin

    # ensuring install transcoding package of Jellyfin
    echo "Ensuring install of transcoding package for Jellyfin Media Server..."
    sleep 1.2

    apt install -y jellyfin-ffmpeg7

    # start and enable Jellyfin with server start
    echo "Enabling and Starting Jellyfin Media Server..."
    sleep 1.2

    systemctl enable jellyfin
    systemctl start jellyfin

    ## allowing outside access through UFW firewall
    ufw allow in 8096

    ## getting IP addr
    HostIP=$(hostname -I | awk '{ print $1 }')


    echo "============================="
    echo "Jellyfin Media Server install complete."
    echo "You should be able to connect to the server at:"
    echo "Http://"$HostIP":8096"
    sleep 5
    clear
}

# Function: Install Intel GPU Drivers for local use
Install_Intel_Drivers() {
    clear

    # Install drivers
    echo "Installing Intel Drivers..."
    sleep 1.2
    apt install -y intel-opencl-icd

    # Install Management tools
    echo "Installing Intel Management Tools..."
    sleep 1.2
    apt install -y intel-gpu-tools

    echo "============================="
    echo "Intel GPU Driver and Managment Tools install complete."
    echo "Please ensure to reboot the system for GPU drivers to apply."
    GPU_Message_About_Jellyfin
    sleep 1.2
    clear
}

# Function: Install nivida GPU Drivers for local use
Install_Nvidia_Drivers() {
    clear

    ### modify /etc/apt/sources.list to incuded "contrib" and "non-free" under your main packages for updates
    echo "Updating Source Repo List for Nivida Drivers..."
    sleep 1.2
    echo "deb http://deb.debian.org/debian/ bookworm contrib non-free" >> /etc/apt/sources.list

    ### update packages after modifications
    echo "Updating to pull new repos..."
    sleep 1.2
    apt update

    ### Install drivers
    echo "Installing Nivida Drivers and dependces..."
    sleep 1.2
    apt install -y nvidia-driver firmware-misc-nonfree

    ## Install Additional codex drivers, these might already be installed do to the drivers you installed earlier.
    echo "Installing Nivida codexes..."
    sleep 1.2
    apt install -y libnvcuvid1 libnvidia-encode1

    ## Install tool for tracking resource use, useful for troubleshooting
    echo "Installing NVTOP..."
    sleep 1.2
    apt install -y nvtop

    echo "============================="
    echo "Nivida GPU Driver, Codexes and Managment Tools install complete."
    echo "Please ensure to reboot the system for GPU drivers to apply."
    GPU_Message_About_Jellyfin
    sleep 1.2
    clear
}

# Function: Message about granting permissions for Jellyfin to GPUs
GPU_Message_About_Jellyfin() {
    echo "============================="
    echo "If using GPU for Jellyfin Transcoding, please ensure correct access for Jellyfin to the GPU, this can be completed with the following steps:"
    echo "      1) Get the passthrough device group. On some releases, the group may be video or input instead of render:"
    echo "          ls -al /dev/dri"
    echo "      2) Grab the group name that the RenderD** is using from the above output, then execute the following"
    echo "          sudo usermod -aG <RenderD**group> jellyfin"
    echo "          sudo systemctl restart jellyfin"
    echo "============================="
    read -n 1 -s -p "Press any key to continue..."
}


# Function: Ask if the user wants to install qemu-guest-agent
Install_Qemu_Guest_Agent() {
    clear
    echo "This is intended only for VM on a proxmox VE environment."
    read -p "please type "confirm" to continue: " choice
    if [[ "$choice" == "confirm" ]]; then
        echo "Installing QEMU agent for VM awareness..."
        sleep 1.2
        apt install -y qemu-guest-agent
        systemctl enable qemu-guest-agent
        systemctl start qemu-guest-agent
        echo "============================="
        echo "QEMU agent install complete."
        sleep 1.2
    else
        echo "exiting function..."
        sleep 1.2
    fi
    clear
}

# Function: setup machine for being template for pve
Setup_Template_For_PVE() {
    clear
    echo "This is intended only for VM on a proxmox VE environment."
    read -p "please type "confirm" to continue: " choice
    if [[ "$choice" == "confirm" ]]; then
        echo "truncating machine id"
        sleep 1.2
        truncate -s 0 /etc/machine-id
    else
        echo "exiting function..."
        sleep 1.2
    fi
    clear
}

# Function: reboot
Closeout_System() {
    echo "System will reboot after all processes finish..."
    echo "Ensuring all process finish..."
    wait
    echo "============================="
    echo "COMPLETED"
    echo "============================="
    echo "Rebooting..."
    echo "You have 90 sec to cancel this reboot process."
    sleep 90
    reboot
}

##############################################
#################### MAIN ####################
##############################################

#calling each function one at a time to run through

Log_Script_Start #Start logging

Welcome_Message #Call welcome message

clear #clear screen of any echo output

Baseline #setup base config

clear #clear screen of any echo output

Main_Menu #Start core of script