-- track-pregnancies.lua
-- Scans for pregnant dwarves and triggers announcements.
--
-- @module = false

local help_text = [=[
track-pregnancies
=================

A manual tracker for dwarf pregnancies.

Usage:
    track-pregnancies

Description:
    When run, this script scans all active citizens and residents.
    If a unit is found to be pregnant:
    1. It prints their name and remaining pregnancy ticks to the DFHack console.
    2. It triggers a standard game announcement (pink text) with a zoom button.

    This script does not run in the background; it only checks when you type the command.
]=]

-- Check if the user asked for help
local args = {...}
if args[1] == 'help' or args[1] == '?' then
    print(help_text)
    return
end

-- ---------------------------------------------------------------------------
-- Core Logic
-- ---------------------------------------------------------------------------

local function scan_pregnancies()
    local count = 0
    print("Scanning for pregnancies...")

    -- Scan all active units
    for _, unit in ipairs(df.global.world.units.active) do
        -- Filter: Alive + Citizen/Resident + Pregnant (Timer > 0)
        if not dfhack.units.isDead(unit) and 
           dfhack.units.isCitizen(unit, true) and 
           unit.pregnancy_timer > 0 then
            
            count = count + 1
            local name = dfhack.units.getReadableName(unit)
            
            -- Print to console
            print(string.format(" - Found: %s (Ticks left: %d)", name, unit.pregnancy_timer))

            -- Send a game announcement (Pink text, creates a 'Z' zoom button)
            -- uses CREATURE_NEW_CITIZEN for the distinct sound/icon style
            dfhack.gui.showZoomAnnouncement(
                df.announcement_type.CREATURE_NEW_CITIZEN,
                unit.pos,
                name .. " is pregnant.",
                COLOR_LIGHT_MAGENTA,
                true
            )
        end
    end

    if count == 0 then
        print("No pregnant dwarves found.")
    else
        print(string.format("\nScan complete. Found %d pregnancies.", count))
    end
end

-- ---------------------------------------------------------------------------
-- Execution
-- ---------------------------------------------------------------------------

scan_pregnancies()
