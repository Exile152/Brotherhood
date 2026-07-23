(function ()
{
	"use strict";

	if (typeof $ === "undefined") return;

	function isReserveEntry(_data)
	{
		return _data !== null && _data !== undefined && (_data.bhReserve === true || _data.bhReserve === 1);
	}

	function decorateReserveEntry(_entry, _data)
	{
		if (!isReserveEntry(_data) || _entry === null || _entry === undefined || _entry.length === 0) return;
		_entry.addClass("bh-reserve-result");
		var badge = _entry.children(".bh-reserve-result-badge");
		if (badge.length === 0)
		{
			badge = $("<div class='bh-reserve-result-badge'><img src='" + Path.GFX + "ui/icons/camp.png'></div>");
			_entry.append(badge);
			badge.bindTooltip({
				contentType: "verbatim",
				tooltip: [
					{ id: 1, type: "title", text: "In Reserve" },
					{ id: 2, type: "description", text: "This brother received experience while remaining in reserve." }
				]
			});
		}
	}

	function decorateStatisticsPanel(_panel, _data)
	{
		if (_panel === null || _panel === undefined || _panel.mStatisticsContainer === null || _panel.mStatisticsContainer === undefined || !$.isArray(_data)) return;
		var entries = _panel.mStatisticsContainer.children(".statistic-container");
		for (var i = 0; i < _data.length && i < entries.length; ++i)
		{
			decorateReserveEntry(entries.eq(i), _data[i]);
		}
	}

	function decorateCurrentResultScreen()
	{
		if (typeof Screens === "undefined" || Screens.TacticalCombatResultScreen === null || Screens.TacticalCombatResultScreen === undefined) return;
		var screen = Screens.TacticalCombatResultScreen;
		if (screen.mStatisticsPanel === null || screen.mStatisticsPanel === undefined || screen.mDataSource === null || screen.mDataSource === undefined) return;
		decorateStatisticsPanel(screen.mStatisticsPanel, screen.mDataSource.mStatistics);
	}

	function installReserveResultBadge()
	{
		if (typeof TacticalCombatResultScreenStatisticsPanel === "undefined") return false;
		if (TacticalCombatResultScreenStatisticsPanel.prototype.bhReserveResultInstalled === true) return true;
		TacticalCombatResultScreenStatisticsPanel.prototype.bhReserveResultInstalled = true;

		var nativeCreateStatisticEntry = TacticalCombatResultScreenStatisticsPanel.prototype.createStatisticEntry;
		TacticalCombatResultScreenStatisticsPanel.prototype.createStatisticEntry = function (_data, _isMiddle)
		{
			var result = nativeCreateStatisticEntry.call(this, _data, _isMiddle);
			decorateReserveEntry(result, _data);
			return result;
		};

		var nativeAddStatistics = TacticalCombatResultScreenStatisticsPanel.prototype.addStatistics;
		TacticalCombatResultScreenStatisticsPanel.prototype.addStatistics = function (_data)
		{
			var result = nativeAddStatistics.call(this, _data);
			decorateStatisticsPanel(this, _data);
			return result;
		};

		decorateCurrentResultScreen();
		return true;
	}

	if (installReserveResultBadge()) return;
	var timer = setInterval(function ()
	{
		if (installReserveResultBadge()) clearInterval(timer);
	}, 100);
})();
