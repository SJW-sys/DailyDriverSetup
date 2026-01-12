# DailyDriverSetup
Setup process for my Daily Driver (computer) that I use outside of work.

## Overview:
I have been a long time Windows user since 95 on my grandparents dial up, but change is constant. As of January 2025, I have been using Linux fulltime as my go to OS for my personal device for Gaming, productivity (bills, learning, etc), webbrowsing, writing and any othe needsr. I hate doing anything with my phone, keyboard and a larger screen (ideally two) and more power will always be my prefrence when an option. I LOVE to learn and tinker, its something that takes up alot of my free time, but because of that I have had a history through the years of breaking my OS. Combine that with a history of builting PC for myself, friends and family (where I got started after videogame system repair on my IT journey), a desire to know more linux distros, and having serveral jobs tied to deployment of new machines; I have always had some sort of script to deploy machines how I want, so I can have a consistant standard of my environment while not having to stress on reconfiguring something.

## My Linux History & Distros:
I have had several shoulder rubs with Linux over the years with attempting to use it as a daily driver (not to mention professional or homelab server experince), but mostly its always fallen off for me after a few weeks do to the complexity of gaming in general, Nividia drivers, and many version of common anticheats not running on linux. Gaming has always won (critical way I keep up with a few freinds over the years), so windows was been constant compainion. With the age of [Proton Compatibility Layer](https://github.com/ValveSoftware/Proton) being driven by valve and [others](https://github.com/GloriousEggroll/proton-ge-custom), the privacy concerns of [windows](https://www.privacyguides.org/en/os/windows/#privacy-notes) and the general [enshitification](https://doctorow.medium.com/https-pluralistic-net-2024-04-04-teach-me-how-to-shruggie-kagi-caaa88c221f2) of windows OS.

### Primary Needs from my distro of choice -
  - While I love to play with tech and push it till it breaks, I want something that just works when I sit down to use it. So I need Reliability and Support (Community and developer).
  - Gaming Support
  - Dual monitor and 144hz support
  - Support, or adjacent tooling, that supports a few of my most favorite programs. IE. VScode, Scrivner, Brave Browser, etc.

### Distro Experince for daily drivers -
Pop OS - 2025-01-01 till 2025-11-01 - overall went with this due to its "up and coming" hotness, wide recommendation for gaming, continuious support and development, lots of community support and similarity to windows GUI. </br>
  - Why move on: I moved on less because of my issues, granted I did have some, and more becasue of better longstanding history, support and reliability of my next distro. </br>
  
Linux Mint - 2025-11-02 till now - my attention was grabed by a dedicated nividia driver manager, more customization, better software updater (granted I have a habit of just doing it via cli) and better support for 144hz monitors.

## Script History:
This project while new to github, has been around for about 10 years starting with some simple powershell scripting. It evolved alot as my needs grew, even existing as a unatteneded-install deployment for windows machines for awhile. But now it sits in its current iteration.

# Development Constant:
This script is constantly changing each time I go to deploy a new machine it gets some tweaks and one of its latest overhauls was a overhaul so it could rely on files for bulk install of packages, closer minicing something you might see in IaC methodologies. Because of its targeted need, it will have shortcomings and sometimes I leave some left overbits in the code for future development, this is not suited for prod environments. I dont even use it for my homelab, granted I did use it for server deployments for awhile in my homelab which you can see from some functionality still in the code. In my homelab I have started to move towards Ansible and other IaC solutions.

## Setup Workflow:

# Manual process not covered by script at this time:


