Clear-Host
$colors = @("Red", "Yellow", "Cyan", "Green", "Magenta", "Blue", "White")

$asciiArt = @'
___________        .__         ____  ___ __________                              .___.__   __   
\_   _____/_____   |__|_______ \   \/  / \______   \  ____     ____    ____    __| _/|__|_/  |_ 
 |    __)  \__  \  |  |\_  __ \ \     /   |       _/_/ __ \   / ___\ _/ __ \  / __ | |  |\   __\
 |     \    / __ \_|  | |  | \/ /     \   |    |   \\  ___/  / /_/  >\  ___/ / /_/ | |  | |  |  
 \___  /   (____  /|__| |__|   /___/\  \  |____|_  / \___  > \___  /  \___  >\____ | |__| |__|  
     \/         \/                   \_/         \/      \/ /_____/       \/      \/            
'@

$asciiArt -split "`n" | ForEach-Object {
    $color = Get-Random -InputObject $colors
    Write-Host $_ -ForegroundColor $color
}

$msgLines = @(
    "[+] Your Sensi Has been Optimized By FairX Regedit",
    "[+] Enjoy Smooth Aim",
    "[+] Zero Aim Jitter",
    "[+] Easy Drag Headshot"
)
$msgLines | ForEach-Object {
    Write-Host $_ -ForegroundColor Red
    Start-Sleep -Milliseconds 300
}

Start-Sleep -Seconds 1

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
using System.Threading;

public class FairXDragAssist {
    [DllImport("user32.dll")]
    public static extern bool GetCursorPos(out POINT lpPoint);

    [DllImport("user32.dll")]
    public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);

    public const int MOUSEEVENTF_MOVE = 0x0001;
    public const int VK_LBUTTON = 0x01;

    [StructLayout(LayoutKind.Sequential)]
    public struct POINT {
        public int X;
        public int Y;
    }

    public static void Run() {
        POINT prev;
        GetCursorPos(out prev);
        bool isHolding = false;
        DateTime pressStart = DateTime.MinValue;

        while (true) {
            Thread.Sleep(5);
            bool lmbDown = (GetAsyncKeyState(VK_LBUTTON) & 0x8000) != 0;

            if (lmbDown) {
                if (!isHolding) {
                    isHolding = true;
                    pressStart = DateTime.Now;
                } else if ((DateTime.Now - pressStart).TotalMilliseconds >= 60) {
                    POINT curr;
                    GetCursorPos(out curr);

                    int deltaY = curr.Y - prev.Y;
                    int deltaX = curr.X - prev.X;

                    if (deltaY < -1) {
                        int correctedX = (int)(deltaX * 0.4);
                        mouse_event(MOUSEEVENTF_MOVE, -correctedX, -4, 0, 0);
                        Thread.Sleep(10);
                    }

                    prev = curr;
                }
            } else {
                isHolding = false;
            }
        }
    }
}
"@

[FairXDragAssist]::Run()
