# DailyDriverSetup
Setup process for my Daily Driver (computer) that I use outside of work.

## Overview:
Being a tech enthusiast I have always been on the move, weather that be new hardware, or distro hopping, or rebuilding a tore apart OS, or need to setup a home server quick and dirty. This presented a problem of loosing alot of time to constantly building to an expected state of configuration. Automating and streamlining the OOBE and setup as much as possible has been a goal for over 10 years for me.

## Design decisions:
**Linux** - Being the unix lover I am, much of my homelab, and all the daily driver machines in my house are linux and debian based. I started with Debian based linux systems, so my deepest knowledge is with that, so many of my deploys are prefaced this way.

**Bash** - Bash is a key deign decision. Its my preferred shell I interact with daily and considering its a universal language standard for linux machines, I need to do minimum steps to run this. This aligns with my core goals of a streamlined automated process. 

**automation/interactive** - While the script is mostly automated process, there are 'Interactive' pieces to the script. Given the scale of the configuration being small, and on linux, much of it completes within moments, which would normally take up to tens of minutes to type out, or remember commands, etc. Interactive approach to several key components is an expectable stop gap to ensure correct configuration on per a machine basis.

**Bulk Installs via file-as-code** - I included a "bulk install" functionality for a variety of install methods (flatpak, package, deb file, docker image). This was a test to align with more common IaC practices on a small scale, allowing file-as-code as a solution to allowing custom setups per a machine. This would prevent future refactor a script for hardcode for every time my standards change for common tools I like to have on my devices. You can see some examples in the files of the script under ./HelperScriptFiles .

**Homelab now Iac** - At a point this was used as setup for my homelab servers, but I have since moved away towards Ansible and other IaC solutions for a more complete one-touch setup. However I do keep this as a 'quick and dirty' fallback method for server deployments.

## Performance and draw backs:
No Windows or MacOS support, this is acceptable as I no longer support any of these machines in my household.

Only Debian based distro supported, this is acceptable as all of my household daily computers are Debian based images.

Being the sole developer on this, Its fully designed to my needs, and this is not intend in any PROD enterprise deployments.

Manually processes still exist outside of this script, see bottom section.

### What it actually does:
This script automates a series of setup tasks on a Brand New Debian install, typically desktop installs, but can be used on server installs in a pinch.
It installs packages, configures services, sets up security tools, and more.
   1) Welcomes user and provides some script info
   2) Installs basic tools and hardening I expect on every linux box I use
   3) access a menu to call functions to execute. Functions either pull in and install functions/apps via a markdown file-as-code, or complete special complex installs.

### AI Note:
AI was used to speed up scripting (~10-15%) in the last refactor, primarily to script out the bulk install functions using context files and rules. Much of the code and concept was written and self designed based on experience and continuous development of this script over the last 10 years.

## Deployment
### Requirements:
- **IMPORTANT** always review any code you plan to execute from the web, I recommend in a test space first.
- Debian based linux system
- sudo installed
- git installed
- An account with sudo level permissions.

### Workflow:

1) Clone git repository to your local machine in your home directory.

  `git clone https://github.com/SJW-sys/DailyDriverSetup.git`

2) navigate into the directory:

  `cd DailyDriverSetup/`

3) Always review external scripts, commands and tools before executing on your system.

  `less LinuxSetupHelperScript.sh`

4) Copy and Modify the install bulk files with the desired installs you want, FILENAMEHERE used as a placeholder. **IMPORTANT** these files are expecting one package per a line in the files, and with the expected filenames.

  'cp ./ExampleFiles/* ./HelperScriptFiles/InstallFiles/'
  'vim ./HelperScriptFiles/InstallFiles/FILENAMEHERE'

5) run the script, its expecting to run with sudo permissions

  `sudo bash LinuxSetupHelperScript.sh`

6) follow prompts for setup of your environment

### Manual processes not covered by script at this time:
- bulk Deb package installs that you have locally
- Software exclusive configurations
- Display configurations
- Setting configurations