(function ()
{
	"use strict";

	if (typeof CharacterScreenPerksModule === "undefined" || typeof $ === "undefined") return;

	function readRolledArchetypes(_brother)
	{
		if (!_brother || !_brother.perkTree) return [];
		for (var row = 0; row < _brother.perkTree.length; ++row)
		{
			for (var index = 0; index < _brother.perkTree[row].length; ++index)
			{
				var perk = _brother.perkTree[row][index];
				if (perk.BH_RolledArchetypes && perk.BH_RolledArchetypes.length) return perk.BH_RolledArchetypes;
			}
		}
		return [];
	}

	function renderInfo(_module)
	{
		var panel = _module.mContainer.BHArchetypeInfoPanel;
		panel.empty();
		$("<div class='bh-archetype-info-title title-font-normal font-bold'>Archetypes</div>").appendTo(panel);

		var rolls = _module.mBHRolledArchetypes || [];
		if (!rolls.length)
		{
			$("<div class='bh-archetype-info-empty text-font-normal'>No Wheel of Fortune rolls recorded.</div>").appendTo(panel);
			return;
		}

		$.each(rolls, function (_, roll)
		{
			var row = $("<div class='bh-archetype-info-row text-font-normal'/>").appendTo(panel);
			var iconFrame = $("<span class='bh-archetype-info-icon-frame'/>").appendTo(row);
			$("<img class='bh-archetype-info-icon'/>").attr("src", Path.GFX + (roll.Icon || "ui/icons/special.png")).appendTo(iconFrame);
			$("<span class='bh-archetype-info-name'/>").text(roll.Name || roll.ID || "Unknown").appendTo(row);
			if (roll.ID)
			{
				row.bindTooltip({
					contentType: "msu-generic",
					modId: DynamicPerks.ID,
					elementId: "PerkGroup+" + roll.ID
				});
			}
		});
	}

	function showInfo(_module)
	{
		renderInfo(_module);
		_module.mContainer.BHArchetypeInfoPanel.stop(true, true).fadeIn(80);
	}

	function hideInfo(_module)
	{
		_module.mContainer.BHArchetypeInfoPanel.stop(true, true).fadeOut(80);
	}

	var originalCreateDIV = CharacterScreenPerksModule.prototype.createDIV;
	CharacterScreenPerksModule.prototype.createDIV = function (_parentDiv)
	{
		originalCreateDIV.call(this, _parentDiv);

		var self = this;
		var container = this.mContainer.SwitchModuleContainer;
		var button = this.mContainer.SwitchModuleButton;
		if (!container || !button) return;

		this.mBHInfoPinned = false;
		this.mBHRolledArchetypes = [];
		container.unbindTooltip();
		container.addClass("bh-archetype-info-container");
		button.off("click").empty().addClass("bh-archetype-info-button");
		$("<span class='bh-archetype-info-letter'>i</span>").appendTo(button);
		this.mContainer.BHArchetypeInfoPanel = $("<div class='bh-archetype-info-panel'/>").hide().appendTo(container);

		button.on("click.bhArchetypeInfo", function (_event)
		{
			_event.stopPropagation();
			self.mBHInfoPinned = !self.mBHInfoPinned;
			if (self.mBHInfoPinned) showInfo(self);
			else hideInfo(self);
		});
		container.on("mouseenter.bhArchetypeInfo", function () { showInfo(self); });
		container.on("mouseleave.bhArchetypeInfo", function () { if (!self.mBHInfoPinned) hideInfo(self); });

		$(document).off("mousedown.bhArchetypeInfo").on("mousedown.bhArchetypeInfo", function (_event)
		{
			if ($(_event.target).closest(container[0]).length) return;
			self.mBHInfoPinned = false;
			hideInfo(self);
		});
	};

	var originalLoad = CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData;
	CharacterScreenPerksModule.prototype.loadPerkTreesWithBrotherData = function (_brother)
	{
		originalLoad.call(this, _brother);
		this.mBHRolledArchetypes = readRolledArchetypes(_brother);
		this.mBHInfoPinned = false;
		if (this.mContainer.BHArchetypeInfoPanel)
		{
			renderInfo(this);
			hideInfo(this);
		}
	};
})();
