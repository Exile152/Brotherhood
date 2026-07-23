// Packaged runtime representation of the current reviewed 0M parent profiles.
// The external Obsidian vault is authoring input and is never read or modified
// by Battle Brothers at runtime.
::Brotherhood.ParentProfileSource <- {
	FormatVersion = 2,
	// SHA-256 over the ordered file-name/file-hash manifest for the fourteen
	// paired 0B canvases and 0M profiles packaged below.
	Fingerprint = "a083851328ba17c781a174733ea040be15ad0868935ed8af114f18bf5e717c8c",
	Profiles = [
		{
			SchemaVersion=1, ID="archer", Name="Archer", Source="0M Archer.md", BuildSource="0B Archer.canvas", ReviewStatus="reviewed",
			Classes=["bow", "headshot", "vision"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=100.0, Acceptable=120.0, Great=135.0, Premium=145.0, Importance=2.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="duelist", Name="Duelist", Source="0M Duelist.md", BuildSource="0B Duelist.canvas", ReviewStatus="reviewed",
			Classes=["sword", "lone", "light_armor", "free_offhand"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=19.0, Acceptable=24.0, Great=30.0, Premium=35.0, Importance=2.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=70.0, Acceptable=90.0, Great=100.0, Premium=110.0, Importance=1.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="hybrid", Name="Hybrid", Source="0M Hybrid.md", BuildSource="0B Hybrid.canvas", ReviewStatus="reviewed",
			Classes=["hybrid", "evasion", "inventory"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="injury_specialist", Name="Injury Specialist", Source="0M Injury Specialist.md", BuildSource="0B Injury Specialist.canvas", ReviewStatus="reviewed",
			Classes=["injury"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=70.0, Acceptable=90.0, Great=100.0, Premium=110.0, Importance=1.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=20.0, Acceptable=40.0, Great=50.0, Premium=60.0, Importance=2.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[{ Name="attack_skill", Members=["melee_skill", "ranged_skill"] }], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="pure_thrower", Name="Pure Thrower", Source="0M Pure Thrower.md", BuildSource="0B Pure Thrower.canvas", ReviewStatus="reviewed",
			Classes=["throwing", "safety"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=19.0, Acceptable=24.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=55.0, Acceptable=70.0, Great=90.0, Premium=105.0, Importance=2.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="qatal_duelist", Name="Qatal Duelist", Source="0M Qatal Duelist.md", BuildSource="0B Qatal Duelist.canvas", ReviewStatus="reviewed",
			Classes=["dagger", "initiative", "cloth_armor", "finisher", "gap_closer"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=100.0, Acceptable=120.0, Great=135.0, Premium=145.0, Importance=2.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="support_frontliner", Name="Support Frontliner", Source="0M Support Frontliner.md", BuildSource="0B Support Frontliner.canvas", ReviewStatus="reviewed",
			Classes=["none"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=2.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			],
			Alternatives=[],
			RoutingClaims=[{ Name="low_fatigue", Stat="fatigue", ActivatesBelow=70.0, Preference="lower", Importance=1.0 }]
		},
		{
			SchemaVersion=1, ID="attack_banner", Name="Attack Banner", Source="0M Attack Banner.md", BuildSource="0B Attack Banner.canvas", ReviewStatus="reviewed",
			Classes=["polearm", "morale"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=2.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=80.0, Acceptable=90.0, Great=100.0, Premium=110.0, Importance=1.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=40.0, Acceptable=55.0, Great=75.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="tank_banner", Name="Tank Banner", Source="0M Tank Banner.md", BuildSource="0B Tank Banner.canvas", ReviewStatus="reviewed",
			Classes=["morale", "tank"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=55.0, Acceptable=70.0, Great=85.0, Premium=95.0, Importance=2.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=40.0, Acceptable=55.0, Great=75.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="tank", Name="Tank", Source="0M Tank.md", BuildSource="0B Tank.canvas", ReviewStatus="reviewed",
			Classes=["tank"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=55.0, Acceptable=70.0, Great=85.0, Premium=95.0, Importance=2.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=80.0, Acceptable=90.0, Great=100.0, Premium=110.0, Importance=1.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=20.0, Acceptable=40.0, Great=50.0, Premium=60.0, Importance=1.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="dancer", Name="Dancer", Source="0M Dancer.md", BuildSource="0B Dancer.canvas", ReviewStatus="inactive",
			Classes=["initiative", "evasion"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=2.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=100.0, Acceptable=120.0, Great=135.0, Premium=145.0, Importance=3.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="fatigue_carry", Name="Fatigue Carry", Source="0M Fatigue Carry.md", BuildSource="0B Fatigue Carry.canvas", ReviewStatus="reviewed",
			Classes=["axe", "fatigue", "kill_chain", "gap_closer"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=19.0, Acceptable=24.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=80.0, Acceptable=90.0, Great=100.0, Premium=110.0, Importance=2.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="reload_ranged", Name="Reload Ranged", Source="0M Reload Ranged.md", BuildSource="0B Reload Ranged.canvas", ReviewStatus="reviewed",
			Classes=["crossbow", "handgonne", "safety", "cloth_armor", "consumable"],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=65.0, Acceptable=85.0, Great=90.0, Premium=95.0, Importance=3.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=10.0, Acceptable=25.0, Great=30.0, Premium=35.0, Importance=1.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=100.0, Acceptable=120.0, Great=135.0, Premium=145.0, Importance=2.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		{
			SchemaVersion=1, ID="tempo", Name="Tempo", Source="0M Tempo.md", BuildSource="0B Tempo.canvas", ReviewStatus="reviewed",
			Classes=[],
			Stats=[
				{ Name="melee_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="melee_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_skill", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="ranged_defense", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="hitpoints_max", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="fatigue", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="resolve", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" },
				{ Name="initiative", IneligibleBelow=null, Bad=null, Acceptable=null, Great=null, Premium=null, Importance=0.0, Direction="higher" }
			], Alternatives=[], RoutingClaims=[]
		},
		// Packaged invalid draft used by the skip-with-diagnostic acceptance path.
		{
			SchemaVersion=1, ID="", Name="", Source="Some forms.md", ReviewStatus="draft",
			Classes=["X"], Stats=[], Alternatives=[], RoutingClaims=[]
		}
	]
};
