(function ()
{
	"use strict";

	function hideDynamicPerksOverviewButton()
	{
		if (typeof $ === "undefined") return;
		if ($("#mod-brotherhood-hide-dpf-overview").length !== 0) return;

		$("<style id='mod-brotherhood-hide-dpf-overview'>.dpf-show-overview-screen-container{display:none!important;}</style>").appendTo("head");
	}

	hideDynamicPerksOverviewButton();

	function addBrotherhoodTacticalStyles()
	{
		if (typeof $ === "undefined") return;
		if ($("#mod-brotherhood-tactical-styles").length !== 0) return;

		$("<style id='mod-brotherhood-tactical-styles'>"
			+ ".ui-control-stats-progressbar.action-points.bh-pursuit-ap,"
			+ ".ui-control-stats-progressbar-preview.action-points.bh-pursuit-ap{"
			+ "filter:hue-rotate(64deg) saturate(1.35) brightness(1.12);"
			+ "}"
			+ "</style>").appendTo("head");
	}

	addBrotherhoodTacticalStyles();

	function getMoraleIcon()
	{
		if (typeof Asset !== "undefined" && Asset.Morale !== undefined) return Asset.Morale;
		return "ui/icons/morale.png";
	}

	function getMoraleStyle()
	{
		if (typeof ProgressbarStyleIdentifier !== "undefined" && ProgressbarStyleIdentifier.Morale !== undefined) return ProgressbarStyleIdentifier.Morale;
		return "morale";
	}

	function getMoraleValueIdentifier(_name, _fallback)
	{
		if (typeof ProgressbarValueIdentifier !== "undefined" && ProgressbarValueIdentifier[_name] !== undefined) return ProgressbarValueIdentifier[_name];
		return _fallback;
	}

	function restoreMoraleRow(_row)
	{
		if (_row === undefined || _row === null) return;

		if ("IconPath" in _row) _row.IconPath = Path.GFX + getMoraleIcon();
		if ("ImagePath" in _row) _row.ImagePath = Path.GFX + getMoraleIcon();
		if ("StyleName" in _row) _row.StyleName = getMoraleStyle();
		if (_row.Row !== undefined && _row.Row !== null && _row.TooltipId !== undefined)
		{
			_row.Row.unbindTooltip();
			_row.Row.bindTooltip({ contentType: "ui-element", elementId: _row.TooltipId });
		}
	}

	function withReachAssetMappedToMorale(_callback)
	{
		if (typeof Asset === "undefined" || typeof ProgressbarStyleIdentifier === "undefined")
		{
			_callback();
			return;
		}

		var oldReachAsset = Asset.rf_Reach;
		var oldReachStyle = ProgressbarStyleIdentifier.rf_Reach;
		Asset.rf_Reach = getMoraleIcon();
		ProgressbarStyleIdentifier.rf_Reach = getMoraleStyle();
		_callback();
		Asset.rf_Reach = oldReachAsset;
		ProgressbarStyleIdentifier.rf_Reach = oldReachStyle;
	}

	if (typeof CharacterScreenStatsModule !== "undefined")
	{
		var characterCreateDIV = CharacterScreenStatsModule.prototype.createDIV;
		CharacterScreenStatsModule.prototype.createDIV = function (_parentDiv)
		{
			var self = this;
			withReachAssetMappedToMorale(function ()
			{
				characterCreateDIV.call(self, _parentDiv);
			});
			restoreMoraleRow(this.mLeftStatsRows.Morale);
		};

		var characterSetProgressbarValues = CharacterScreenStatsModule.prototype.setProgressbarValues;
		CharacterScreenStatsModule.prototype.setProgressbarValues = function (_data)
		{
			characterSetProgressbarValues.call(this, _data);
			if (this.mLeftStatsRows !== undefined && this.mLeftStatsRows.Morale !== undefined)
			{
				restoreMoraleRow(this.mLeftStatsRows.Morale);
				this.setProgressbarValue(
					this.mLeftStatsRows.Morale.Progressbar,
					_data,
					getMoraleValueIdentifier("Morale", "morale"),
					getMoraleValueIdentifier("MoraleMax", "moraleMax"),
					getMoraleValueIdentifier("MoraleLabel", "moraleLabel")
				);
			}
		};
	}

	if (typeof TacticalScreenTurnSequenceBarModule !== "undefined")
	{
		var setPursuitActionPointBar = function (_module, _data)
		{
			if (_module.mLeftStatsRows === undefined || _module.mLeftStatsRows.ActionPoints === undefined) return;
			if (_module.mLeftStatsRows.ActionPoints.Progressbar === null || _module.mLeftStatsRows.ActionPoints.ProgressbarPreview === null) return;

			var hasPursuitAP = _data !== undefined
				&& _data !== null
				&& typeof _data === "object"
				&& "bhPursuitActionPoints" in _data
				&& _data.bhPursuitActionPoints > 0;

			_module.mLeftStatsRows.ActionPoints.Progressbar.toggleClass("bh-pursuit-ap", hasPursuitAP);
			_module.mLeftStatsRows.ActionPoints.ProgressbarPreview.toggleClass("bh-pursuit-ap", hasPursuitAP);
		};

		var tacticalCreateDIV = TacticalScreenTurnSequenceBarModule.prototype.createDIV;
		TacticalScreenTurnSequenceBarModule.prototype.createDIV = function (_parentDiv)
		{
			var self = this;
			withReachAssetMappedToMorale(function ()
			{
				tacticalCreateDIV.call(self, _parentDiv);
			});
			restoreMoraleRow(this.mLeftStatsRows.Morale);
		};

		var tacticalBindTooltips = TacticalScreenTurnSequenceBarModule.prototype.bindTooltips;
		TacticalScreenTurnSequenceBarModule.prototype.bindTooltips = function ()
		{
			tacticalBindTooltips.call(this);
			if (this.mLeftStatsRows !== undefined) restoreMoraleRow(this.mLeftStatsRows.Morale);
		};

		var tacticalUpdateStatsPanel = TacticalScreenTurnSequenceBarModule.prototype.updateStatsPanel;
		TacticalScreenTurnSequenceBarModule.prototype.updateStatsPanel = function (_data)
		{
			tacticalUpdateStatsPanel.call(this, _data);
			setPursuitActionPointBar(this, _data);
		};
	}
})();
