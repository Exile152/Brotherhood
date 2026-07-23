(function ()
{
	"use strict";

	if (typeof CharacterScreenPerksModule === "undefined" || typeof $ === "undefined") return;

	var state = window.BrotherhoodArchetypeGlow || {
		ShiftDown: false,
		ActiveModule: null
	};
	window.BrotherhoodArchetypeGlow = state;

	var nativeColors = [
		"rgba(67, 214, 255, 0.98)",
		"rgba(255, 215, 92, 0.98)",
		"rgba(90, 255, 166, 0.98)",
		"rgba(106, 143, 255, 0.98)",
		"rgba(255, 151, 72, 0.98)"
	];
	var wildColors = [
		"rgba(255, 72, 218, 0.98)",
		"rgba(190, 95, 255, 0.98)",
		"rgba(255, 78, 112, 0.98)",
		"rgba(226, 82, 255, 0.98)",
		"rgba(255, 116, 196, 0.98)"
	];

	function eachPerk(_module, _callback)
	{
		if (_module === null || _module === undefined || !_module.mPerkTree) return;
		$.each(_module.mPerkTree, function (_, _row)
		{
			$.each(_row, function (__, _perk)
			{
				_callback(_perk);
			});
		});
	}

	function clearGlow(_module)
	{
		eachPerk(_module, function (_perk)
		{
			if (!_perk.PerkGroupOverlay) return;
			_perk.PerkGroupOverlay
				.removeClass("bh-archetype-glow")
				.css("box-shadow", "none")
				.removeData("bh-archetype-glow-shadows");
		});
		if (state.ActiveModule === _module) state.ActiveModule = null;
	}

	function getSourceIDs(_perk, _field)
	{
		return _perk && $.isArray(_perk[_field]) ? _perk[_field] : [];
	}

	function addGlow(_perk, _color, _isHovered)
	{
		if (!_perk.PerkGroupOverlay) return;
		var shadows = _perk.PerkGroupOverlay.data("bh-archetype-glow-shadows") || [];
		var innerSize = _isHovered ? 5 : 3;
		var outerSize = _isHovered ? 12 : 9;
		shadows.push("0 0 " + innerSize + "px 3px " + _color);
		shadows.push("0 0 " + outerSize + "px 6px " + _color);
		_perk.PerkGroupOverlay
			.data("bh-archetype-glow-shadows", shadows)
			.addClass("bh-archetype-glow")
			.css("box-shadow", shadows.join(", "));
	}

	function glowMatchingSource(_module, _hoveredPerk, _sourceID, _field, _color)
	{
		eachPerk(_module, function (_innerPerk)
		{
			if (_innerPerk === _hoveredPerk) return;
			if (getSourceIDs(_innerPerk, _field).indexOf(_sourceID) === -1) return;
			addGlow(_innerPerk, _color, false);
		});
	}

	function applyGlow(_module, _hoveredPerk)
	{
		clearGlow(_module);
		var nativeIDs = getSourceIDs(_hoveredPerk, "BH_NativeArchetypeIDs");
		var wildIDs = getSourceIDs(_hoveredPerk, "BH_WildArchetypeIDs");
		if (nativeIDs.length === 0 && wildIDs.length === 0) return;

		state.ActiveModule = _module;
		addGlow(_hoveredPerk, "rgba(255, 255, 255, 0.98)", true);
		$.each(nativeIDs, function (_index, _sourceID)
		{
			glowMatchingSource(_module, _hoveredPerk, _sourceID, "BH_NativeArchetypeIDs", nativeColors[_index % nativeColors.length]);
		});
		$.each(wildIDs, function (_index, _sourceID)
		{
			glowMatchingSource(_module, _hoveredPerk, _sourceID, "BH_WildArchetypeIDs", wildColors[_index % wildColors.length]);
		});
	}

	var originalAttachEventHandler = CharacterScreenPerksModule.prototype.attachEventHandler;
	CharacterScreenPerksModule.prototype.attachEventHandler = function (_perk)
	{
		originalAttachEventHandler.call(this, _perk);
		var self = this;

		_perk.Container.off(".bhArchetypeGlow");
		_perk.Container.on("keydown.bhArchetypeGlow", function (_event)
		{
			if (_event.keyCode !== 16 && !_event.shiftKey) return;
			state.ShiftDown = true;
			applyGlow(self, _perk);
		});
		_perk.Container.on("keyup.bhArchetypeGlow", function (_event)
		{
			if (_event.keyCode !== 16) return;
			state.ShiftDown = false;
			clearGlow(self);
		});
		_perk.Container.on("mouseenter.bhArchetypeGlow", function ()
		{
			if (state.ShiftDown) applyGlow(self, _perk);
		});
		_perk.Container.on("mouseleave.bhArchetypeGlow", function ()
		{
			clearGlow(self);
		});
	};

	var originalRemovePerksEventHandler = CharacterScreenPerksModule.prototype.removePerksEventHandler;
	CharacterScreenPerksModule.prototype.removePerksEventHandler = function (_perkTree)
	{
		clearGlow(this);
		if (_perkTree)
		{
			$.each(_perkTree, function (_, _row)
			{
				$.each(_row, function (__, _perk)
				{
					if (_perk.Container) _perk.Container.off(".bhArchetypeGlow");
				});
			});
		}
		originalRemovePerksEventHandler.call(this, _perkTree);
	};

	$(document)
		.off("keydown.bhArchetypeGlow keyup.bhArchetypeGlow")
		.on("keydown.bhArchetypeGlow", function (_event)
		{
			if (_event.keyCode === 16) state.ShiftDown = true;
		})
		.on("keyup.bhArchetypeGlow", function (_event)
		{
			if (_event.keyCode !== 16) return;
			state.ShiftDown = false;
			clearGlow(state.ActiveModule);
		});

	$(window)
		.off("blur.bhArchetypeGlow")
		.on("blur.bhArchetypeGlow", function ()
		{
			state.ShiftDown = false;
			clearGlow(state.ActiveModule);
		});
})();
