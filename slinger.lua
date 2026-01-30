import customtkinter as ctk

# [ SHADOW_X ]: SLINGERHUB EXECUTOR INTERFACE 🤫
ctk.set_appearance_mode("dark")

class SlingerHub(ctk.CTk):
    def __init__(self):
        super().__init__()
        # Title window ganti jadi SlingerHub 👿
        self.title(" [ SHADOW_X ] : SLINGERHUB ")
        self.geometry("700x400")
        self.configure(fg_color="#0f0f1e") 

        # --- SIDEBAR (KIRI) ---
        self.sidebar = ctk.CTkFrame(self, width=150, corner_radius=0, fg_color="#16162d")
        self.sidebar.pack(side="left", fill="y")
        
        # Label utama ganti jadi SlingerHub 🤫
        self.logo = ctk.CTkLabel(self.sidebar, text="SLINGERHUB", font=("Inter", 18, "bold"), text_color="#a2a2ff")
        self.logo.pack(pady=20)

        menus = ["Main", "Exclusive", "Shop", "Teleport", "Settings"]
        for menu in menus:
            btn = ctk.CTkButton(self.sidebar, text=menu, fg_color="transparent", anchor="w", hover_color="#25254d")
            btn.pack(fill="x", padx=10, pady=5)

        # --- MAIN CONTENT ---
        self.main_frame = ctk.CTkFrame(self, fg_color="transparent")
        self.main_frame.pack(side="right", expand=True, fill="both", padx=20, pady=20)

        self.title_label = ctk.CTkLabel(self.main_frame, text="Ultra Blatant V3", font=("Inter", 18, "bold"))
        self.title_label.place(x=10, y=10)

        self.blatant_switch = ctk.CTkSwitch(self.main_frame, text="", progress_color="#7a2dfc")
        self.blatant_switch.place(x=350, y=15)

        self.create_input("Complete Delay", "0.258", 60)
        self.create_input("Cancel Delay", "0.305", 110)
        self.create_input("Re-Cast Delay", "0.00001", 160)

        self.fps_btn = ctk.CTkButton(self, text="Unlock FPS", fg_color="#7a2dfc", width=120)
        self.fps_btn.place(x=200, y=320)

    def create_input(self, label_text, default_val, y_pos):
        lbl = ctk.CTkLabel(self.main_frame, text=label_text, font=("Inter", 14))
        lbl.place(x=10, y=y_pos)
        entry = ctk.CTkEntry(self.main_frame, width=150, fg_color="#1c1c3a", border_color="#3a3a5e")
        entry.insert(0, default_val)
        entry.place(x=210, y=y_pos)

if __name__ == "__main__":
    app = SlingerHub()
    app.mainloop()
