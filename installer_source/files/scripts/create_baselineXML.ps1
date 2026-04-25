# ============================================================
# Portable USB Drive Integrity Suite
# File: create_baselineXML.ps1
# Author: sussjb99
# Version: 1.1
# Last Modified: <2026-04-25>
# Copyright (c) 2026 sussjb99. All rights reserved.
# Licensed under the MIT License. See LICENSE.txt for details.
# ============================================================

param ([string]$DriveLetter)
$ErrorActionPreference = "Stop"

# --- 1. Path Setup ---
if ([string]::IsNullOrWhiteSpace($DriveLetter)) { exit 1 }

$JustDrive = $DriveLetter.Substring(0,1) + ":"
$CleanDrive = $JustDrive + "\"
$ExcludeToken = "Integrity_Check"

$Bin          = "$CleanDrive$ExcludeToken\bin"
$Logs         = "$CleanDrive$ExcludeToken\logs"
$FileGen      = "$Bin\FileListGen.exe"
$HashDeep     = "$Bin\hashdeep64.exe"
$Baseline     = "$Logs\baseline.xml"
$AuditList    = "$Logs\baseline_files.txt"

# Force UTF-8 for tool communication
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# Ensure Logs directory exists
if (-not (Test-Path $Logs)) { New-Item -Path $Logs -ItemType Directory -Force | Out-Null }

# --- 2. Inventory Drive (C++ Accelerated - Standard Paths) ---
Write-Host "Step 1: Inventorying $CleanDrive (Standard Paths)..." -ForegroundColor Cyan

& $FileGen "$CleanDrive" "$AuditList"

# --- 2.5 Logic Check ---
if (-not (Test-Path $AuditList)) { Write-Host "Error: FileListGen failed."; exit 4 }
$FileCount = (Get-Content $AuditList).Count

# --- 3. Generate Master Baseline XML ---
Write-Host "Step 2: Hashing $FileCount files... " -ForegroundColor Yellow -NoNewline

# Start the hashing process as a background job so the spinner can run
$HashJob = Start-Job -ScriptBlock {
    param($exe, $list, $output)
    & $exe -c md5 -l -d -f "$list" | Set-Content -Path "$output" -Encoding utf8
} -ArgumentList $HashDeep, $AuditList, $Baseline

# --- Spinner Animation ---
$spinner = @('|', '/', '-', '\')
$i = 0

while ($HashJob.State -eq "Running") {
    Write-Host "`rStep 2: Hashing $FileCount files... $($spinner[$i % 4])" -ForegroundColor Yellow -NoNewline
    $i++
    Start-Sleep -Milliseconds 150
}

# Clean up the job and move to a new line
Receive-Job -Job $HashJob | Out-Null
Remove-Job -Job $HashJob
Write-Host "`rStep 2: Hashing $FileCount files... Done!   " -ForegroundColor Yellow

# --- 4. Cleanup ---
# if (Test-Path $AuditList) { Remove-Item $AuditList -Force }

if (Test-Path $Baseline) {
    Write-Host "`nSuccess! Master Baseline created at: $Baseline" -ForegroundColor Green
}