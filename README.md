# TCS-SSE
Script intensive modification plugin for the game TESV: Skyrim SE. It makes torches cast shadows according to the limitations regarding how the game engine draws dynamic lights.

## Prerequisites
* Skyrim SE Script Extender
* MCM SE

## Background
Bethesda Game Studios, the developers of the Creation Engine, are well known to design their games to look and feel similarly across all platforms. This means that there are drawbacks in certain areas, and more specifically in this case, they limit ceratin aspects.
One of those things is the amount of graphically rendered dynamic lights (shadow casting lights). Dynamic light algorithms are very expensive on the hardware, hence they are limited to a total amount of 4 rendered synchronously.
The player can use torches in the game but the light will be static and hence cast no shadows. This mod aims to change that without modifying the surrounding scene and instead scanning the scene to check if it is possible at that specific instance in time.

## How it works
Each time the player equips a torch or casts a light spell the script checks for cell change. If there was a change the cell is scanned for lights by using efficient SKSE functions and compare these lights to a CK FormList of dynamic lihts. If more than three (3) are present within a rendered radius around the player a normal static light will be equipped, else a dynamic light.

## Performance
#### Player module
The player module only affects the player and scripts only fire according to event listeners. Scripts only run when the specific spell is cast or item is equipped and there are hence no background scripts running.
#### NPC module
The NPC module affect all human/elf NPCs, including followers. The script runs in the background scanning the cell for close by NPCs. The script then runs on each individual NPC and is hence less performance friendly. However, scripts are removed from NPCs who are outside a customisable radius and the scan is using CK variables.

## Debugging/troubleshooting
Check the provided debug section within the MCM menu.
