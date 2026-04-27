# Application Manifest & Security Declaration
**Project:** PUDIS (Portable USB  Drive Integrity Suite)  
**Status:** Beta (Public Funding Phase)

## 1. Technical Justification
This software performs low-level hardware analysis to ensure data integrity on USB storage devices. Because it interacts directly with disk sectors to bypass OS caching, certain security scanners may flag these behaviors as "Defense Evasion" (T1006) or "Discovery" (T1082/T1083). These actions are strictly functional and required for accurate hardware stress testing.

## 2. File Inventory & Integrity Hashes
| Path | Purpose | SHA-256 Hash (Integrity Check) |
| :--- | :--- | :--- |
| `!VERIFY_INTEGRITY.BAT` | Main UI and menu controller | [SHA256_HASH_HERE] |
| `bin/deviceinfo.exe` | Gathers storage device hardware specs | [SHA256_HASH_HERE] |
| `bin/full_probe.exe` | Identifies all connected storage volumes | [SHA256_HASH_HERE] |
| `bin/surface_scan.exe` | Performs sector-level read/write tests | [SHA256_HASH_HERE] |
| `bin/par2.exe` | Parity engine for data recovery | [SHA256_HASH_HERE] |
| `bin/corruptor.exe` | Simulates bit rot for testing logic | [SHA256_HASH_HERE] |
| `bin/hashdeep64.exe` | High-performance hashing engine | [SHA256_HASH_HERE] |
| `bin/smartctl.exe` | Reports S.M.A.R.T. hardware health | [SHA256_HASH_HERE] |

## 3. Behavioral Disclosure (MITRE ATT&CK Mapping)
To assist security auditors and automated scanners, we disclose the following expected behaviors[cite: 3]:
* **T1006 (Direct Volume Access):** Required by `surface_scan.exe` to verify physical sectors[cite: 3].
* **T1055 (Process Injection):** High-performance threading used for parallel parity calculation in `par2.exe`[cite: 3].
* **T1082/T1083 (Discovery):** Used to identify the correct physical drive and prevent accidental data loss on the system drive (C:)[cite: 3].
* **T1553.002 (Code Signing):** Files are currently **Self-Signed** due to project funding status[cite: 3].

## 4. External Dependencies
The following binaries are included as open-source dependencies:
* **par2.exe**: Forked from [sussjb99/par2cmdline](https://github.com/sussjb99/par2cmdline--filelist.txt). (Modified to support @filelist.txt).
* **hashdeep64.exe**: Sourced from [jessek/hashdeep](https://github.com/jessek/hashdeep).
* **smartctl.exe**: Sourced from [smartmontools](https://github.com/smartmontools/smartmontools).

---
*This manifest was generated to ensure transparency and verify that the distributed binaries match the developer's intent.*
