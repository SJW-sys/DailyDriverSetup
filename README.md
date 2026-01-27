# DailyDriverSetup
Setup process for my Daily Driver (computer) that I use outside of work.

## Overview:
I have been a long time Windows user since 95 on my grandparents dial up, but change is constant. As of January 2025, I have been using Linux fulltime as my go to OS for my personal device for Gaming, productivity (bills, learning, etc), web browsing, writing and any other needs. I hate doing anything with my phone, keyboard and a larger screen (ideally two) and more power will always be my preference when an option. I LOVE to learn and tinker, its something that takes up most of my free time, but because of that I have had a history through the years of breaking my OS. Combine that with a history of building PC for myself, friends and family (where I got started after video game system repair on my IT journey), a desire to know more linux distro's, and having several jobs tied to deployment of new machines; I have always had some sort of script to deploy machines how I want, so I can have a consistent standard of my environment while not having to stress on reconfiguring something.

## My Linux History & Distros:
I have had several shoulder rubs with Linux over the years with attempting to use it as a daily driver (not to mention professional or homelab server experience), but mostly its always fallen off for me after a few weeks do to the complexity of gaming in general, Nvidia drivers, and many version of common game anti-cheats not running on linux. Gaming has always won (critical way I keep up with a few friends over the years), so windows was been constant companion. With the age of [Proton Compatibility Layer](https://github.com/ValveSoftware/Proton) being driven by valve and [others](https://github.com/GloriousEggroll/proton-ge-custom), the privacy concerns of [windows](https://www.privacyguides.org/en/os/windows/#privacy-notes) and the general [enshitification](https://doctorow.medium.com/https-pluralistic-net-2024-04-04-teach-me-how-to-shruggie-kagi-caaa88c221f2) of windows OS.

### Primary Needs from my distro of choice:
  - While I love to play with tech and push it till it breaks, I want something that just works when I sit down to use it. So I need Reliability, Support (Community and developer) and something that just works out of the box.
  - Gaming Support
  - Dual monitor and 144hz support
  - Support, or adjacent tooling, that supports a few of my most favorite programs. IE. VScode, Scrivener, Brave Browser, etc.

### Distro Experience for daily drivers:
Pop OS - 2025-01-01 till 2025-11-01 - overall went with this due to its "up and coming" hotness, wide recommendation for gaming, continuous support and development, lots of community support and similarity to windows GUI. </br>
  - Why move on: I moved on less because of my issues, granted I did have some, and more because of better longstanding history, support and reliability of my next distro. </br>
  
Linux Mint - 2025-11-02 till now - with this shift, both my machined (laptop & desktop) have been shifted to this my attention was grabbed by a dedicated nvidia driver manager, more customization, better software updater (granted I have a habit of just doing it via cli) and better support for 144hz monitors.

## Script History:
This project while new to github, has been around for about 10 years starting with some simple powershell scripting. Its evolved as my needs grew, even existing as a unattended-install deployment for windows machines for awhile. But now it sits in its current iteration.

# Development Constant:
This script is constantly changing each time I go to deploy a new machine it gets some tweaks and one of its latest overhauls was a overhaul so it could rely on files for bulk install of packages, closer mincing something you might see in IaC methodologies. Because of its targeted need, it will have shortcomings and sometimes I leave some left over bits in the code for future development, this is not suited for prod environments. I don't even use it for my homelab, granted I did use it for server deployments for awhile in my homelab which you can see from some functionality still in the code. In my homelab I have started to move towards Ansible and other IaC solutions.

## Requirements:
- Debian based linux system
- sudo installed

## Setup Workflow:

1) clone git repository to your local machine in your home directory

2) modify the install files with the desired installs you want, these files are expecting one package per a line in the files.

3) run the script, its expecting to run with sudo permissions
    sudo shell LinuxSetupHelperScript.sh

4) follow prompts for setup of your environment

# Manual process not covered by script at this time:
- Deb file installs that you have locally
- Software configurations
- Display configurations