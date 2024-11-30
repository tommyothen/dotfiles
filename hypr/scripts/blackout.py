#!/usr/bin/env python3
import tkinter as tk
from argparse import ArgumentParser

class BlackoutWindow:
    def __init__(self, monitor=1):
        self.root = tk.Tk()
        self.root.title("Monitor Blackout")
        
        # Remove window decorations
        self.root.overrideredirect(True)
        
        # Create black canvas
        self.canvas = tk.Canvas(self.root, bg='black', highlightthickness=0)
        self.canvas.pack(fill=tk.BOTH, expand=True)
        
        # Bind escape key to close window
        self.root.bind('<Escape>', lambda e: self.root.destroy())
        
        # Get monitor geometry
        self.root.update_idletasks()
        monitors = self.get_monitor_geometry()
        
        if monitor < len(monitors):
            x, y, width, height = monitors[monitor]
            self.root.geometry(f"{width}x{height}+{x}+{y}")
        
        self.root.attributes('-fullscreen', True)
        self.root.focus_force()
    
    def get_monitor_geometry(self):
        # Get geometry of all monitors
        monitors = []
        for i in range(self.root.winfo_screenwidth()):
            try:
                geo = self.root.winfo_screenwidth(), self.root.winfo_screenheight()
                if geo not in monitors:
                    monitors.append(geo)
            except:
                break
        return [(0, 0, w, h) for w, h in monitors]
    
    def run(self):
        self.root.mainloop()

if __name__ == "__main__":
    parser = ArgumentParser(description="Create a black fullscreen window on specified monitor")
    parser.add_argument('-m', '--monitor', type=int, default=1,
                       help="Monitor number (default: 1)")
    args = parser.parse_args()
    
    app = BlackoutWindow(args.monitor)
    app.run()
    