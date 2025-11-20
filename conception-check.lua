-- conception-check.lua
-- Monitors for NEW pregnancies by tracking state changes.
-- @module = true

local repeatUtil = require('repeat-util')

-- ---------------------------------------------------------------------------
-- Configuration
-- ---------------------------------------------------------------------------

-- Check every half-day (approx 600 ticks). 
-- Frequent checks ensure we catch them shortly after it happens.
local CHECK_FREQUENCY = 600 

-- Session storage to remember who is already known to be pregnant
local notified_ids = {}

-- ---------------------------------------------------------------------------
-- Core Logic
-- ---------------------------------------------------------------------------

-- Helper: Check if a unit is a relevant citizen
local function is_valid_target(unit)
    return dfhack.units.isCitizen(unit, true) and 
           not dfhack.units.isDead(unit) and
           unit.pregnancy_timer > 0
end

-- 1. Silent Initialization
-- Runs once when script starts. Memorizes existing pregnancies so we don't alert on them.
local function initialize_memory()
    local count = 0
    for _, unit in ipairs(df.global.world.units.active) do
        if is_valid_target(unit) then
            notified_ids[unit.id] = true
            count = count + 1
        end
    end
    print(string.format("Conception Monitor initialized. silently tracking %d existing pregnancies.", count))
end

-- 2. Active Monitor
-- Runs repeatedly. Alerts only if a pregnant dwarf is NOT in memory.
local function check_new_conceptions()
    for _, unit in ipairs(df.global.world.units.active) do
        if is_valid_target(unit) then
            
            -- If we haven't seen this pregnancy before...
            if not notified_ids[unit.id] then
                
                local name = dfhack.units.getReadableName(unit)
                
                -- 1. Trigger Game Announcement (Zoomable)
                dfhack.gui.showZoomAnnouncement(
                    df.announcement_type.CREATURE_NEW_CITIZEN,
                    unit.pos,
                    "Conception Alert: " .. name .. " has conceived!",
                    COLOR_LIGHT_MAGENTA,
                    true
                )

                -- 2. Console Output
                print(string.format("New Conception: %s (Ticks left: %d)", name, unit.pregnancy_timer))

                -- 3. Add to memory so we don't alert again this session
                notified_ids[unit.id] = true
            end
        else
            -- Cleanup: If they are no longer pregnant (gave birth), remove from memory
            -- This allows them to trigger the alert again if they get pregnant a second time later in the session.
            if notified_ids[unit.id] and unit.pregnancy_timer <= 0 then
                notified_ids[unit.id] = nil
            end
        end
    end
end

-- ---------------------------------------------------------------------------
-- Enable/Disable Handling
-- ---------------------------------------------------------------------------

local args = {...}
local loop_name = 'conception-monitor'

if args[1] == "disable" or args[1] == "stop" then
    repeatUtil.cancel(loop_name)
    print("Conception monitor disabled.")
else
    -- Stop any running instance to prevent duplicates
    repeatUtil.cancel(loop_name)

    -- 1. Populate the list silently first
    initialize_memory()

    -- 2. Start the repeating check
    repeatUtil.scheduleEvery(loop_name, CHECK_FREQUENCY, 'ticks', check_new_conceptions)
    print("Conception monitor running. Checking every " .. CHECK_FREQUENCY .. " ticks.")
end

return _ENV
