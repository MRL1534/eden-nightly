# SPDX-FileCopyrightText: 2023 yuzu Emulator Project
# SPDX-License-Identifier: GPL-3.0-or-later

$ErrorActionPreference = "Stop"

$LLVMVer = "21.1.5"
$ExeFile = "LLVM-$LLVMVer-win64.exe"
$Uri = "https://github.com/llvm/llvm-project/releases/download/llvmorg-$LLVMVer/$ExeFile"
$Destination = "./$ExeFile"

echo "Downloading LLVM $LLVMVer from $Uri"
$WebClient = New-Object System.Net.WebClient
$WebClient.DownloadFile($Uri, $Destination)
echo "Finished downloading $ExeFile"

$LLVM_PATH = "C:\Program Files\LLVM"
$Arguments = "/S /D=$LLVM_PATH"

echo "Installing LLVM $LLVMVer"
$InstallProcess = Start-Process -FilePath $Destination -NoNewWindow -PassThru -Wait -ArgumentList $Arguments
$ExitCode = $InstallProcess.ExitCode

if ($ExitCode -ne 0) {
    echo "Error installing LLVM $LLVMVer (Error: $ExitCode)"
    Exit $ExitCode
}

echo "Finished installing LLVM $LLVMVer"

if ("$env:GITHUB_ACTIONS" -eq "true") {
    echo "$LLVM_PATH\bin" | Out-File -FilePath $env:GITHUB_PATH -Encoding utf8 -Append
}
