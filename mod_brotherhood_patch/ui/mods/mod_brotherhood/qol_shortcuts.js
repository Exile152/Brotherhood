(function ()
{
	"use strict";

	if (typeof $ === "undefined") return;

	var BrotherhoodQOL = window.BrotherhoodQOL || {};
	window.BrotherhoodQOL = BrotherhoodQOL;
	BrotherhoodQOL.ShiftDown = false;
	BrotherhoodQOL.ActivePaperdollModule = null;

	function installPaperdollDropWrapper()
	{
		if (typeof $.fn.assignPaperdollItemDragAndDrop !== "function" || $.fn.assignPaperdollItemDragAndDrop.bhVolleyWrapped === true) return;
		var nativeAssignPaperdollItemDragAndDrop = $.fn.assignPaperdollItemDragAndDrop;
		$.fn.assignPaperdollItemDragAndDrop = function (_parent, _dragStartCallback, _dragEndCallback, _dropCallback)
		{
			var paperdollModule = BrotherhoodQOL.ActivePaperdollModule;
			var wrappedDrop = _dropCallback;
			if (typeof _dropCallback === "function")
			{
				wrappedDrop = function (_source, _target, _proxy)
				{
					if (_proxy.data("bhInventoryDropHandled") === true) return;
					var sourceData = _proxy.data("item") || {};
					var targetData = _target.data("item") || {};
					var targetSlot = _target.data("bhEquipmentSlotType");
					var sourceSlot = sourceData.slotType;
					var sourceOwner = sourceData.owner;
					var targetOwner = targetData.owner;
					var sourceIsHand = sourceSlot === CharacterScreenIdentifier.ItemSlot.Mainhand || sourceSlot === CharacterScreenIdentifier.ItemSlot.Offhand;
					var targetIsHand = targetSlot === CharacterScreenIdentifier.ItemSlot.Mainhand || targetSlot === CharacterScreenIdentifier.ItemSlot.Offhand;
					var sourceIsBag = sourceOwner === CharacterScreenIdentifier.ItemOwner.Backpack;
					var sourceIsStash = sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash;
					var targetIsBag = targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack;
					if (paperdollModule !== null && paperdollModule !== undefined)
					{
						paperdollModule.mDataSource.bhLogInventoryDrop(sourceData.entityId, sourceData.itemId, sourceOwner, sourceSlot, targetOwner, targetSlot, sourceData.index, sourceData.bhVolleyThrowing === true);
					}
					var moveBetweenHands = paperdollModule !== null && paperdollModule !== undefined &&
						sourceOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll && sourceIsHand && targetIsHand &&
						sourceSlot !== targetSlot && sourceData.entityId != null && sourceData.itemId != null;
					if (moveBetweenHands)
					{
						sourceData.isAllowedToDrop = true;
						_proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
						paperdollModule.mDataSource.bhMoveEquippedHandItem(sourceData.entityId, sourceData.itemId, targetSlot);
						return;
					}
					var moveHandToBag = paperdollModule !== null && paperdollModule !== undefined &&
						sourceOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll && sourceIsHand && targetIsBag &&
						sourceData.entityId != null && sourceData.itemId != null;
					if (moveHandToBag)
					{
						sourceData.isAllowedToDrop = true;
						_proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
						paperdollModule.mDataSource.bhMoveEquippedHandItemToBag(sourceData.entityId, sourceData.itemId, targetData.index);
						return;
					}
					var moveBagToHand = paperdollModule !== null && paperdollModule !== undefined &&
						sourceIsBag && targetIsHand &&
						sourceData.entityId != null && sourceData.itemId != null;
					if (moveBagToHand)
					{
						sourceData.isAllowedToDrop = true;
						_proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
						paperdollModule.mDataSource.bhMoveBagItemToHand(sourceData.entityId, sourceData.itemId, sourceData.index, targetSlot);
						return;
					}
					var moveStashToHand = paperdollModule !== null && paperdollModule !== undefined &&
						sourceIsStash && targetIsHand && sourceData.itemId != null;
					if (moveStashToHand)
					{
						sourceData.isAllowedToDrop = true;
						_proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
						paperdollModule.mDataSource.bhMoveStashItemToHand(sourceData.itemId, sourceData.index, targetSlot);
						return;
					}
					return _dropCallback(_source, _target, _proxy);
				};
			}
			return nativeAssignPaperdollItemDragAndDrop.call(this, _parent, _dragStartCallback, _dragEndCallback, wrappedDrop);
		};
		$.fn.assignPaperdollItemDragAndDrop.bhVolleyWrapped = true;
	}
	installPaperdollDropWrapper();

	function getActiveCharacterDataSource()
	{
		if (typeof Screens === "undefined") return null;
		if (Screens.TacticalCharacterScreen !== undefined && Screens.TacticalCharacterScreen !== null && Screens.TacticalCharacterScreen.isConnected()) return Screens.TacticalCharacterScreen.mDataSource;
		if (Screens.WorldCharacterScreen !== undefined && Screens.WorldCharacterScreen !== null && Screens.WorldCharacterScreen.isConnected()) return Screens.WorldCharacterScreen.mDataSource;
		return null;
	}

	// Mod JavaScript can load after the vanilla character screen has already
	// created its drop callbacks. Bind the custom transactions directly to
	// those live DOM slots as well, so they do not depend on construction order.
	function installLivePaperdollDropTargets()
	{
		if (typeof CharacterScreenIdentifier === "undefined" || typeof $.fn.drop !== "function") return;
		$(".paperdoll-module .ui-control.paperdoll-item").each(function ()
		{
			var target = $(this);
			if (target.data("bhLiveDropBound") === true) return;
			target.data("bhLiveDropBound", true);
			target.drop(function (_event, dd)
			{
				var proxy = $(dd.proxy);
				if (proxy.data("bhInventoryDropHandled") === true) return;
				var sourceData = proxy.data("item") || {};
				var targetData = target.data("item") || {};
				var sourceOwner = sourceData.owner;
				var targetOwner = targetData.owner;
				var sourceSlot = sourceData.slotType;
				var targetSlot = targetData.slotType;
				var sourceIsHand = sourceSlot === CharacterScreenIdentifier.ItemSlot.Mainhand || sourceSlot === CharacterScreenIdentifier.ItemSlot.Offhand;
				var targetIsHand = targetSlot === CharacterScreenIdentifier.ItemSlot.Mainhand || targetSlot === CharacterScreenIdentifier.ItemSlot.Offhand;
				var sourceIsBag = sourceOwner === CharacterScreenIdentifier.ItemOwner.Backpack;
				var sourceIsStash = sourceOwner === CharacterScreenIdentifier.ItemOwner.Stash;
				var targetIsBag = targetOwner === CharacterScreenIdentifier.ItemOwner.Backpack;
				var dataSource = getActiveCharacterDataSource();
				if (dataSource === null || sourceData.itemId == null || (!sourceIsStash && sourceData.entityId == null)) return;

				dataSource.bhLogInventoryDrop(sourceData.entityId, sourceData.itemId, sourceOwner, sourceSlot, targetOwner, targetSlot, sourceData.index, sourceData.bhVolleyThrowing === true);
				if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll && sourceIsHand && targetIsHand && sourceSlot !== targetSlot)
				{
					sourceData.isAllowedToDrop = true;
					proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
					dataSource.bhMoveEquippedHandItem(sourceData.entityId, sourceData.itemId, targetSlot);
				}
				else if (sourceOwner === CharacterScreenIdentifier.ItemOwner.Paperdoll && sourceIsHand && targetIsBag)
				{
					sourceData.isAllowedToDrop = true;
					proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
					dataSource.bhMoveEquippedHandItemToBag(sourceData.entityId, sourceData.itemId, targetData.index);
				}
				else if (sourceIsBag && targetIsHand)
				{
					sourceData.isAllowedToDrop = true;
					proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
					dataSource.bhMoveBagItemToHand(sourceData.entityId, sourceData.itemId, sourceData.index, targetSlot);
				}
				else if (sourceIsStash && targetIsHand)
				{
					sourceData.isAllowedToDrop = true;
					proxy.data("item", sourceData).data("bhInventoryDropHandled", true);
					dataSource.bhMoveStashItemToHand(sourceData.itemId, sourceData.index, targetSlot);
				}
			}, { mode: "intersect" });
		});
	}

	function isRightClick(_event)
	{
		return _event.button === 2 || _event.which === 3;
	}

	function isMiddleClick(_event)
	{
		return _event.button === 1 || _event.which === 2 || _event.button === 4 || _event.which === 4 || _event.buttons === 4;
	}

	function stopEvent(_event)
	{
		_event.preventDefault();
		_event.stopPropagation();
		_event.stopImmediatePropagation();
	}

	function isTransferable(_data)
	{
		return _data !== undefined
			&& _data !== null
			&& _data.isEmpty === false
			&& _data.itemId != null
			&& _data.entityId != null
			&& _data.slotType != null
			&& _data.slotType !== CharacterScreenIdentifier.ItemSlot.None
			&& _data.isUsable !== true
			&& _data.isUsable !== 1;
	}

	function detachVanillaRightClickHandlers(_element)
	{
		var node = _element[0];
		if (node.bhVanillaRightClickDetached === true) return node.bhVanillaRightClickHandlers || [];
		node.bhVanillaRightClickDetached = true;
		node.bhVanillaRightClickHandlers = [];
		if (typeof $._data !== "function") return node.bhVanillaRightClickHandlers;

		var events = $._data(node, "events");
		var handlers = events !== undefined && events !== null && events.mousedown !== undefined ? events.mousedown.slice() : [];
		for (var i = 0; i < handlers.length; ++i)
		{
			var handler = handlers[i].handler;
			if (typeof handler !== "function") continue;
			var source = handler.toString().replace(/\s+/g, "");
			if (source.indexOf(".which===3") === -1 || source.indexOf("_callback") === -1) continue;
			node.bhVanillaRightClickHandlers.push(handler);
			_element.off("mousedown", handler);
		}
		return node.bhVanillaRightClickHandlers;
	}

	function restoreVanillaRightClickHandlers(_element)
	{
		if (_element === undefined || _element === null || _element.length === 0) return;
		var node = _element[0];
		if (node.bhVanillaRightClickDetached !== true) return;
		var handlers = node.bhVanillaRightClickHandlers || [];
		for (var i = 0; i < handlers.length; ++i) _element.on("mousedown", handlers[i]);
		node.bhVanillaRightClickDetached = false;
	}

	function setTransferShortcutEnabled(_element, _enabled)
	{
		if (_element === undefined || _element === null || _element.length === 0) return;
		var node = _element[0];
		node.bhCustomTransferEnabled = _enabled === true;
		// The capture-phase custom handler already stops a transfer it handles.
		// Keep vanilla right-click attached so excluded usable items, such as the
		// lute, still return to the stash instead of being left with no handler.
		restoreVanillaRightClickHandlers(_element);
	}

	function reloadItemTooltip()
	{
		if (typeof Screens === "undefined" || Screens.Tooltip === null || !Screens.Tooltip.isConnected()) return;
		var tooltip = Screens.Tooltip.getModule("TooltipModule");
		if (tooltip !== null && tooltip.mCurrentData !== null && tooltip.mCurrentData.contentType === "ui-item") tooltip.reloadUITooltip();
	}

	function applyLockedState(_element, _locked)
	{
		if (_element === undefined || _element === null || _element.length === 0) return;
		var isLocked = _locked === true;
		var itemData = _element.data("item") || {};
		var owner = itemData.owner == null ? "" : String(itemData.owner).toLowerCase();
		var showSmallLockIcon = owner.indexOf("stash") !== -1 || owner.indexOf("backpack") !== -1;
		var usesNativeLockIcon = typeof _element.showPaperdollLockedImage === "function";
		if (usesNativeLockIcon) _element.showPaperdollLockedImage(isLocked && !showSmallLockIcon);
		var layer = _element.children(".bh-item-lock-layer");
		if (layer.length === 0)
		{
			var lockIcon = typeof Asset !== "undefined" && Asset.ICON_LOCKED !== undefined ? Asset.ICON_LOCKED : "ui/icons/icon_locked.png";
			layer = $("<div class='bh-item-lock-layer'><img class='bh-item-lock-icon' src='" + Path.GFX + lockIcon + "'></div>");
			_element.append(layer);
		}
		_element.toggleClass("bh-item-locked", isLocked);
		layer.toggle(isLocked);
		layer.find(".bh-item-lock-icon").toggle(isLocked && showSmallLockIcon);
	}

	function setLocalLockState(_element, _locked, _reloadTooltip)
	{
		var data = _element.data("item") || {};
		data.bhLocked = _locked === true;
		_element.data("item", data);
		applyLockedState(_element, data.bhLocked);
		if (_reloadTooltip !== false) reloadItemTooltip();
	}

	function bindLockShortcut(_element, _callback)
	{
		if (_element === undefined || _element === null || _element.length === 0) return;
		var node = _element[0];
		// Item locking is intentionally disabled. Clear any saved UI state but do
		// not attach Shift+right-click or Shift+middle-click listeners.
		setLocalLockState(_element, false, false);
		node.bhItemLockBound = true;
		node.bhItemLockCallback = null;
		node.bhToggleItemLock = null;
	}

	function bindTransferShortcut(_element, _callback, _enabled)
	{
		if (_element === undefined || _element === null || _element.length === 0) return;
		var node = _element[0];
		node.bhRightTransferCallback = _callback;
		setTransferShortcutEnabled(_element, _enabled);
		if (node.bhRightTransferBound === true) return;
		node.bhRightTransferBound = true;

		function shouldHandle(_event)
		{
			return node.bhCustomTransferEnabled === true && isRightClick(_event) && _event.altKey !== true && isTransferable($(node).data("item"));
		}

		node.addEventListener("mousedown", function (_event)
		{
			if (!isRightClick(_event)) return;
			if (node.bhCustomTransferEnabled !== true) return;
			if ((_event.shiftKey === true || BrotherhoodQOL.ShiftDown === true) && typeof node.bhToggleItemLock === "function")
			{
				node.bhSuppressNextRightClick = true;
				setTimeout(function () { node.bhSuppressNextRightClick = false; }, 500);
				node.bhToggleItemLock(_event);
				return;
			}
			if (!shouldHandle(_event))
			{
				var vanillaRightClickHandlers = node.bhVanillaRightClickHandlers || [];
				if (vanillaRightClickHandlers.length === 0) return;
				node.bhSuppressNextRightClick = true;
				setTimeout(function () { node.bhSuppressNextRightClick = false; }, 500);
				stopEvent(_event);
				for (var i = 0; i < vanillaRightClickHandlers.length; ++i)
				{
					vanillaRightClickHandlers[i].call(node, _event);
				}
				return;
			}
			var data = $(node).data("item");
			node.bhSuppressNextRightClick = true;
			setTimeout(function () { node.bhSuppressNextRightClick = false; }, 500);
			stopEvent(_event);
			node.bhRightTransferCallback(data, _event.ctrlKey === true);
		}, true);

		node.addEventListener("mouseup", function (_event)
		{
			if (node.bhCustomTransferEnabled === true && isRightClick(_event) && (node.bhSuppressNextRightClick === true || shouldHandle(_event))) stopEvent(_event);
		}, true);

		node.addEventListener("contextmenu", function (_event)
		{
			if (node.bhCustomTransferEnabled !== true) return;
			if (node.bhSuppressNextRightClick !== true && !shouldHandle(_event)) return;
			stopEvent(_event);
			setTimeout(function () { node.bhSuppressNextRightClick = false; }, 0);
		}, true);
	}

	function forceProceduralImageReload(_image, _imagePath)
	{
		if (_image == null || _image.length === 0 || _imagePath == null) return;
		if (_image.attr("src") === _imagePath)
			_image.attr("src", "");
	}

	function installVolleyPortraitRefresh()
	{
		if (typeof CharacterScreenLeftPanelHeaderModule !== "undefined"
			&& CharacterScreenLeftPanelHeaderModule.prototype.setPortraitImage.bhVolleyWrapped !== true)
		{
			var nativeSetPortraitImage = CharacterScreenLeftPanelHeaderModule.prototype.setPortraitImage;
			CharacterScreenLeftPanelHeaderModule.prototype.setPortraitImage = function (_imagePath)
			{
				forceProceduralImageReload(this.mPortraitImage, Path.PROCEDURAL + _imagePath);
				return nativeSetPortraitImage.call(this, _imagePath);
			};
			CharacterScreenLeftPanelHeaderModule.prototype.setPortraitImage.bhVolleyWrapped = true;
		}

		if ($.fn.assignListBrotherImage != null && $.fn.assignListBrotherImage.bhVolleyWrapped !== true)
		{
			var nativeAssignListBrotherImage = $.fn.assignListBrotherImage;
			$.fn.assignListBrotherImage = function (_imagePath, _imageOffsetX, _imageOffsetY, _imageScale)
			{
				var imageLayer = this.find(".image-layer:first");
				if (imageLayer.length > 0 && _imagePath !== null)
					forceProceduralImageReload(imageLayer.find("img:first"), _imagePath);
				return nativeAssignListBrotherImage.call(this, _imagePath, _imageOffsetX, _imageOffsetY, _imageScale);
			};
			$.fn.assignListBrotherImage.bhVolleyWrapped = true;
		}
	}

	function installHooks()
	{
	if (typeof CharacterScreenInventoryListModule !== "undefined" && CharacterScreenInventoryListModule.prototype.bhQOLShortcutsInstalled !== true)
	{
		CharacterScreenInventoryListModule.prototype.bhQOLShortcutsInstalled = true;
		var nativeInventoryCreateItemSlot = CharacterScreenInventoryListModule.prototype.createItemSlot;
		CharacterScreenInventoryListModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
		{
			var self = this;
			var result = nativeInventoryCreateItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
			bindLockShortcut(result, function (_data, _callback)
			{
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.entityId, _data.itemId, _data.owner], _callback);
			});
			bindTransferShortcut(result, function (_data, _toBag)
			{
				if (_toBag) self.mDataSource.dropInventoryItemIntoBag(_data.entityId, _data.itemId, _data.index, null);
				else self.mDataSource.equipInventoryItem(_data.entityId, _data.itemId, null);
			}, false);
			return result;
		};

		var nativeInventoryAssignItemToSlot = CharacterScreenInventoryListModule.prototype.assignItemToSlot;
		CharacterScreenInventoryListModule.prototype.assignItemToSlot = function (_entityId, _owner, _slot, _item)
		{
			var result = nativeInventoryAssignItemToSlot.call(this, _entityId, _owner, _slot, _item);
			var self = this;
			// A stash item's native entityId is null. Do not replace it with the
			// currently selected brother: this slot data also drives drag/drop and
			// right-click transfers, and the injected ID becomes stale after changing
			// characters, routing an item to the previously selected brother.
			bindLockShortcut(_slot, function (_data, _callback)
			{
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.entityId, _data.itemId, _data.owner], _callback);
			});
			var data = _slot.data("item") || {};
			data.bhLocked = _item !== null && _item !== undefined && _item.bhLocked === true;
			data.bhCustomItemSwapping = _item !== null && _item !== undefined && _item.bhCustomItemSwapping === true;
			data.bhVolleyThrowing = _item !== null && _item !== undefined && _item.bhVolleyThrowing === true;
			_slot.data("item", data);
			bindTransferShortcut(_slot, function (_data, _toBag)
			{
				if (_toBag) self.mDataSource.dropInventoryItemIntoBag(_data.entityId, _data.itemId, _data.index, null);
				else self.mDataSource.equipInventoryItem(_data.entityId, _data.itemId, null);
			}, data.bhCustomItemSwapping);
			applyLockedState(_slot, data.bhLocked);
			return result;
		};

		var nativeInventoryRemoveItemFromSlot = CharacterScreenInventoryListModule.prototype.removeItemFromSlot;
		CharacterScreenInventoryListModule.prototype.removeItemFromSlot = function (_slot)
		{
			var result = nativeInventoryRemoveItemFromSlot.call(this, _slot);
			setTransferShortcutEnabled(_slot, false);
			setLocalLockState(_slot, false, false);
			return result;
		};
	}

	if (typeof CharacterScreenPaperdollModule !== "undefined" && CharacterScreenPaperdollModule.prototype.bhQOLShortcutsInstalled !== true)
	{
		CharacterScreenPaperdollModule.prototype.bhQOLShortcutsInstalled = true;
		var nativePaperdollAssignEquipment = CharacterScreenPaperdollModule.prototype.assignEquipment;
		CharacterScreenPaperdollModule.prototype.assignEquipment = function (_brotherId, _data)
		{
			var hasMainhand = _data !== null && _data !== undefined && CharacterScreenIdentifier.ItemSlot.Mainhand in _data;
			var hasOffhand = _data !== null && _data !== undefined && CharacterScreenIdentifier.ItemSlot.Offhand in _data;
			if (hasMainhand && hasOffhand)
			{
				var data = $.extend({}, _data);
				data[CharacterScreenIdentifier.ItemSlot.Mainhand] = $.extend({}, _data[CharacterScreenIdentifier.ItemSlot.Mainhand]);
				data[CharacterScreenIdentifier.ItemSlot.Mainhand][CharacterScreenIdentifier.ItemFlag.IsBlockingOffhand] = false;
				return nativePaperdollAssignEquipment.call(this, _brotherId, data);
			}
			return nativePaperdollAssignEquipment.call(this, _brotherId, _data);
		};

		var nativeCreateBagSlot = CharacterScreenPaperdollModule.prototype.createBagSlot;
		CharacterScreenPaperdollModule.prototype.createBagSlot = function (_index, _parentDiv, _screenDiv)
		{
			var self = this;
			installPaperdollDropWrapper();
			BrotherhoodQOL.ActivePaperdollModule = this;
			var result;
			try { result = nativeCreateBagSlot.call(this, _index, _parentDiv, _screenDiv); }
			finally { BrotherhoodQOL.ActivePaperdollModule = null; }
			bindLockShortcut(result.Container, function (_data, _callback)
			{
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.entityId, _data.itemId, _data.owner], _callback);
			});
			bindTransferShortcut(result.Container, function (_data, _toBag)
			{
				if (_toBag)
				{
					self.mDataSource.dropBagItemIntoInventory(_data.entityId, _data.itemId, _data.index, null);
				}
				else
				{
					self.mDataSource.equipBagItem(_data.entityId, _data.itemId, null);
				}
				self.mDataSource.getInventoryModule().updateSlotsLabel();
			}, false);
			return result;
		};

		var nativeCreateEquipmentSlot = CharacterScreenPaperdollModule.prototype.createEquipmentSlot;
		CharacterScreenPaperdollModule.prototype.createEquipmentSlot = function (_slot, _parentDiv, _screenDiv)
		{
			var self = this;
			installPaperdollDropWrapper();
			BrotherhoodQOL.ActivePaperdollModule = this;
			var result;
			try { result = nativeCreateEquipmentSlot.call(this, _slot, _parentDiv, _screenDiv); }
			finally { BrotherhoodQOL.ActivePaperdollModule = null; }
			_slot.Container.data("bhEquipmentSlotType", _slot.SlotType);
			bindLockShortcut(_slot.Container, function (_data, _callback)
			{
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.entityId, _data.itemId, _data.owner], _callback);
			});
			bindTransferShortcut(_slot.Container, function (_data, _toBag)
			{
				if (_toBag) self.mDataSource.dropPaperdollItemIntoBag(_data.entityId, _data.itemId, null);
				else self.mDataSource.dropPaperdollItem(_data.entityId, _data.itemId, null);
				self.mDataSource.getInventoryModule().updateSlotsLabel();
			}, false);
			return result;
		};

		var nativePaperdollAssignItemToSlot = CharacterScreenPaperdollModule.prototype.assignItemToSlot;
		CharacterScreenPaperdollModule.prototype.assignItemToSlot = function (_slot, _entityId, _item, _isBlocked)
		{
			var result = nativePaperdollAssignItemToSlot.call(this, _slot, _entityId, _item, _isBlocked);
			var self = this;
			bindLockShortcut(_slot.Container, function (_data, _callback)
			{
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.entityId, _data.itemId, _data.owner], _callback);
			});
			var data = _slot.Container.data("item") || {};
			data.bhLocked = _item !== null && _item !== undefined && _item.bhLocked === true;
			data.bhCustomItemSwapping = _item !== null && _item !== undefined && _item.bhCustomItemSwapping === true;
			data.bhVolleyThrowing = _item !== null && _item !== undefined && _item.bhVolleyThrowing === true;
			if (_item === null || _item === undefined) data.slotType = _slot.SlotType;
			_slot.Container.data("item", data);
			bindTransferShortcut(_slot.Container, function (_data, _toBag)
			{
				var isBagSlot = CharacterScreenIdentifier.ItemFlag.IsBagSlot in _slot && _slot[CharacterScreenIdentifier.ItemFlag.IsBagSlot] === true;
				if (isBagSlot)
				{
					if (!_toBag) self.mDataSource.equipBagItem(_data.entityId, _data.itemId, null);
				}
				else if (_toBag) self.mDataSource.dropPaperdollItemIntoBag(_data.entityId, _data.itemId, null);
				else self.mDataSource.dropPaperdollItem(_data.entityId, _data.itemId, null);
				self.mDataSource.getInventoryModule().updateSlotsLabel();
			}, data.bhCustomItemSwapping);
			applyLockedState(_slot.Container, data.bhLocked);
			return result;
		};

		var nativePaperdollRemoveItemFromSlot = CharacterScreenPaperdollModule.prototype.removeItemFromSlot;
		CharacterScreenPaperdollModule.prototype.removeItemFromSlot = function (_slot)
		{
			var result = nativePaperdollRemoveItemFromSlot.call(this, _slot);
			setTransferShortcutEnabled(_slot.Container, false);
			setLocalLockState(_slot.Container, false, false);
			return result;
		};
	}

	if (typeof CharacterScreenDatasource !== "undefined" && CharacterScreenDatasource.prototype.bhMoveEquippedHandItem === undefined)
	{
		CharacterScreenDatasource.prototype.bhApplyInventoryMoveResult = function (data)
		{
			if (data === undefined || data === null || typeof data !== "object") return;
			if (ErrorCode.Key in data)
			{
				this.notifyEventListener(ErrorCode.Key, data[ErrorCode.Key]);
				return;
			}
			this.mInventoryModule.updateSlotsLabel();
			if (CharacterScreenIdentifier.QueryResult.Stash in data) this.updateStash(data[CharacterScreenIdentifier.QueryResult.Stash]);
			if (CharacterScreenIdentifier.QueryResult.Brother in data) this.updateBrother(data[CharacterScreenIdentifier.QueryResult.Brother]);
		};
		CharacterScreenDatasource.prototype.bhMoveEquippedHandItem = function (_brotherId, _sourceItemId, _targetSlot)
		{
			var self = this;
			SQ.call(this.mSQHandle, "onBrotherhoodMoveEquippedHandItem", [_brotherId, _sourceItemId, _targetSlot], function (data)
			{
				self.bhApplyInventoryMoveResult(data);
			});
		};
		CharacterScreenDatasource.prototype.bhMoveEquippedHandItemToBag = function (_brotherId, _sourceItemId, _targetBagIndex)
		{
			var self = this;
			SQ.call(this.mSQHandle, "onBrotherhoodMoveEquippedHandItemToBag", [_brotherId, _sourceItemId, _targetBagIndex], function (data)
			{
				self.bhApplyInventoryMoveResult(data);
			});
		};
		CharacterScreenDatasource.prototype.bhMoveBagItemToHand = function (_brotherId, _sourceItemId, _sourceBagIndex, _targetSlot)
		{
			var self = this;
			SQ.call(this.mSQHandle, "onBrotherhoodMoveBagItemToHand", [_brotherId, _sourceItemId, _sourceBagIndex, _targetSlot], function (data)
			{
				self.bhApplyInventoryMoveResult(data);
			});
		};
		CharacterScreenDatasource.prototype.bhMoveStashItemToHand = function (_sourceItemId, _sourceItemIndex, _targetSlot)
		{
			var selectedBrother = this.getSelectedBrother();
			if (selectedBrother === null || !(CharacterScreenIdentifier.Entity.Id in selectedBrother)) return;
			var self = this;
			SQ.call(this.mSQHandle, "onEquipInventoryItem", [selectedBrother[CharacterScreenIdentifier.Entity.Id], _sourceItemId, _sourceItemIndex, _targetSlot], function (data)
			{
				self.bhApplyInventoryMoveResult(data);
			});
		};
		CharacterScreenDatasource.prototype.bhLogInventoryDrop = function (_brotherId, _itemId, _sourceOwner, _sourceSlot, _targetOwner, _targetSlot, _sourceIndex, _isVolleyThrowing)
		{
			SQ.call(this.mSQHandle, "onBrotherhoodInventoryDropDiagnostic", [_brotherId, _itemId, _sourceOwner, _sourceSlot, _targetOwner, _targetSlot, _sourceIndex, _isVolleyThrowing], function () {});
		};
	}

	if (typeof WorldTownScreenShopDialogModule !== "undefined" && WorldTownScreenShopDialogModule.prototype.bhQOLShortcutsInstalled !== true)
	{
		WorldTownScreenShopDialogModule.prototype.bhQOLShortcutsInstalled = true;
		var nativeShopTriggerSwapFlow = WorldTownScreenShopDialogModule.prototype.triggerSwapFlow;
		WorldTownScreenShopDialogModule.prototype.triggerSwapFlow = function (_sourceItemIdx, _sourceItemOwner, _targetItemIdx, _targetItemOwner)
		{
			if (_sourceItemOwner === WorldTownScreenShop.ItemOwner.Stash && _targetItemOwner !== _sourceItemOwner)
			{
				var sourceSlot = this.querySlotByIndex(this.mStashSlots, _sourceItemIdx);
				var sourceData = sourceSlot !== null ? sourceSlot.data("item") : null;
				if (sourceData !== null && sourceData !== undefined && sourceData.bhLocked === true) return;
			}
			return nativeShopTriggerSwapFlow.apply(this, arguments);
		};

		var nativeShopCreateItemSlot = WorldTownScreenShopDialogModule.prototype.createItemSlot;
		WorldTownScreenShopDialogModule.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
		{
			var self = this;
			var result = nativeShopCreateItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
			bindLockShortcut(result, function (_data, _callback)
			{
				if (_data.owner !== WorldTownScreenShop.ItemOwner.Stash) return;
				SQ.call(self.mSQHandle, "onBrotherhoodToggleItemLock", [_data.id, _data.owner], _callback);
			});
			var node = result[0];
			node.addEventListener("mousedown", function (_event)
			{
				var data = $(node).data("item") || {};
				if (isRightClick(_event) && data.bhLocked === true) stopEvent(_event);
			}, true);
			return result;
		};

		var nativeShopAssignItemToSlot = WorldTownScreenShopDialogModule.prototype.assignItemToSlot;
		WorldTownScreenShopDialogModule.prototype.assignItemToSlot = function (_owner, _slot, _item)
		{
			var result = nativeShopAssignItemToSlot.call(this, _owner, _slot, _item);
			var data = _slot.data("item") || {};
			data.bhLocked = _item !== null && _item !== undefined && _item.bhLocked === true;
			_slot.data("item", data);
			applyLockedState(_slot, data.bhLocked);
			return result;
		};

		var nativeShopRemoveItemFromSlot = WorldTownScreenShopDialogModule.prototype.removeItemFromSlot;
		WorldTownScreenShopDialogModule.prototype.removeItemFromSlot = function (_slot)
		{
			var result = nativeShopRemoveItemFromSlot.call(this, _slot);
			setLocalLockState(_slot, false, false);
			return result;
		};
	}

	if (typeof TacticalCombatResultScreenLootPanel !== "undefined" && TacticalCombatResultScreenLootPanel.prototype.bhQOLShortcutsInstalled !== true)
	{
		TacticalCombatResultScreenLootPanel.prototype.bhQOLShortcutsInstalled = true;
		var nativeLootCreateItemSlot = TacticalCombatResultScreenLootPanel.prototype.createItemSlot;
		TacticalCombatResultScreenLootPanel.prototype.createItemSlot = function (_owner, _index, _parentDiv, _screenDiv)
		{
			var self = this;
			var result = nativeLootCreateItemSlot.call(this, _owner, _index, _parentDiv, _screenDiv);
			bindLockShortcut(result, function (_data, _callback)
			{
				if (_data.owner !== TacticalCombatResultScreenIdentifier.ItemOwner.Stash) return;
				SQ.call(self.mDataSource.mSQHandle, "onBrotherhoodToggleItemLock", [_data.id, _data.owner], _callback);
			});
			return result;
		};

		var nativeLootAssignItemToSlot = TacticalCombatResultScreenLootPanel.prototype.assignItemToSlot;
		TacticalCombatResultScreenLootPanel.prototype.assignItemToSlot = function (_owner, _slot, _item)
		{
			var result = nativeLootAssignItemToSlot.call(this, _owner, _slot, _item);
			var data = _slot.data("item") || {};
			data.bhLocked = _item !== null && _item !== undefined && _item.bhLocked === true;
			_slot.data("item", data);
			applyLockedState(_slot, data.bhLocked);
			return result;
		};

		var nativeLootRemoveItemFromSlot = TacticalCombatResultScreenLootPanel.prototype.removeItemFromSlot;
		TacticalCombatResultScreenLootPanel.prototype.removeItemFromSlot = function (_slot)
		{
			var result = nativeLootRemoveItemFromSlot.call(this, _slot);
			setLocalLockState(_slot, false, false);
			return result;
		};
	}

	installVolleyPortraitRefresh();
	}

	installHooks();
	document.addEventListener("mousedown", function (_event)
	{
		var node = _event.target;
		while (node !== null && node !== document && typeof node.bhToggleItemLock !== "function") node = node.parentNode;
		if (node === null || node === document) return;
		if (typeof node.bhToggleItemLock === "function") node.bhToggleItemLock(_event);
	}, true);
	var installTimer = setInterval(function ()
	{
		installHooks();
		var inventoryReady = typeof CharacterScreenInventoryListModule !== "undefined" && CharacterScreenInventoryListModule.prototype.bhQOLShortcutsInstalled === true;
		var paperdollReady = typeof CharacterScreenPaperdollModule !== "undefined" && CharacterScreenPaperdollModule.prototype.bhQOLShortcutsInstalled === true;
		var shopReady = typeof WorldTownScreenShopDialogModule !== "undefined" && WorldTownScreenShopDialogModule.prototype.bhQOLShortcutsInstalled === true;
		var lootReady = typeof TacticalCombatResultScreenLootPanel !== "undefined" && TacticalCombatResultScreenLootPanel.prototype.bhQOLShortcutsInstalled === true;
		if (inventoryReady && paperdollReady && shopReady && lootReady) clearInterval(installTimer);
	}, 250);
	installLivePaperdollDropTargets();
	setInterval(installLivePaperdollDropTargets, 250);

	$(document).on("keydown.brotherhood-lock-shift", function (_event)
	{
		if (_event.which === 16 || _event.keyCode === 16 || _event.shiftKey === true) BrotherhoodQOL.ShiftDown = true;
	});

	$(document).on("keyup.brotherhood-lock-shift", function (_event)
	{
		if (_event.which === 16 || _event.keyCode === 16) BrotherhoodQOL.ShiftDown = false;
	});

	$(document).on("keydown.brotherhood-end-turn", function (_event)
	{
		var isSpace = _event.which === 32 || _event.keyCode === 32 || _event.code === "Space";
		if (!isSpace || _event.shiftKey !== true || typeof Screens === "undefined" || Screens.TacticalScreen === undefined || !Screens.TacticalScreen.isConnected()) return;
		_event.preventDefault();
		_event.stopPropagation();
		_event.stopImmediatePropagation();
		SQ.call(Screens.TacticalScreen.mSQHandle, "onBrotherhoodEndActiveTurn", null);
	});

	$(window).on("blur.brotherhood-lock-shift", function ()
	{
		BrotherhoodQOL.ShiftDown = false;
	});
})();
