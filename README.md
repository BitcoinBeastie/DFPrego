This project is dedicated to **Torpornaut** and the DF community.
Here’s to better family planning (and inevitable FUN).
May your fortress crumble in the most entertaining way possible!

# DFHack Pregnancy Trackers

A collection of Lua scripts for **Dwarf Fortress** (requires [DFHack](https://www.google.com/url?sa=E&q=https%3A%2F%2Fdocs.dfhack.org%2F)) that allow players to monitor population growth more closely.

The game natively hides pregnancy status until the moment of birth. These scripts bridge that gap, offering both manual audits and real-time alerts when conceptions occur.

## Scripts Included

### 1. conception-check.lua (Background Monitor)

A "set it and forget it" background service. It runs silently while you play and alerts you the moment a new pregnancy is detected.

- **Smart Initialization:** When started, it scans and "memorizes" all currently pregnant dwarves without triggering alerts. This prevents notification spam when you load a save file.
    
- **Real-Time Monitoring:** Checks the unit list every half-day (approx. 600 ticks).
    
- **State Tracking:** Only alerts when a dwarf transitions from "Not Pregnant" to "Pregnant."
    
- **Repeatable:** If a dwarf gives birth, they are removed from the internal memory, allowing the script to trigger again if they conceive a second time years later.
    

### 2. track-pregnancies.lua (Manual Scanner)

A manual auditing tool. Run this command whenever you want a full status report of your fortress.

- **Full Audit:** Scans all active citizens and residents immediately.
    
- **Dual Reporting:**
    
    - Prints a list of names and remaining pregnancy ticks to the DFHack console.
        
    - Triggers a standard game announcement (pink text) with a zoom button for every pregnant dwarf found.
        

---

## Installation

1. Download the .lua files from this repository.
    
2. Navigate to your Dwarf Fortress installation folder.
    
3. Place both files into the following directory:  
    \Dwarf Fortress\dfhack-config\scripts\
    

(If the scripts folder does not exist inside dfhack-config, you can create it).
