if (!("Brotherhood" in getroottable())) return;

// Private Park-Miller streams. No call here reads, seeds, or consumes the
// global Battle Brothers RNG, so unrelated game activity cannot change a deal.
::Brotherhood.ParentRNG <- {
	Modulus = 2147483647,
	Multiplier = 16807,
	Quotient = 127773,
	Remainder = 2836,

	function normalizeSeed( _seed )
	{
		local value = _seed % (this.Modulus - 1);
		if (value < 0) value = -value;
		return value + 1;
	},

	function stableStringHash( _value, _salt = 0 )
	{
		local hash = this.normalizeSeed(5381 + _salt);
		for (local i = 0; i < _value.len(); ++i)
		{
			hash = ((hash * 33) + _value[i]) % (this.Modulus - 1);
			if (hash < 0) hash += this.Modulus - 1;
		}
		return hash + 1;
	},

	function deriveRecruitSeed( _actor )
	{
		// getUID() is created with the actor and serialized by the engine.
		return this.normalizeSeed(_actor.getUID() + this.stableStringHash("brotherhood-parent-generation-v2"));
	},

	function deriveSeed( _seed, _namespace )
	{
		return this.normalizeSeed(_seed + this.stableStringHash(_namespace));
	},

	function create( _seed )
	{
		return { State = this.normalizeSeed(_seed) };
	},

	function next( _state )
	{
		local high = _state.State / this.Quotient;
		local low = _state.State % this.Quotient;
		local test = this.Multiplier * low - this.Remainder * high;
		_state.State = test > 0 ? test : test + this.Modulus;
		return _state.State;
	},

	function nextInt( _state, _minimum, _maximum )
	{
		if (_maximum < _minimum) throw "parent RNG received an invalid range";
		return _minimum + this.next(_state) % (_maximum - _minimum + 1);
	},

	function nextUnit( _state )
	{
		return this.next(_state).tofloat() / this.Modulus.tofloat();
	},

	function createTieState( _context )
	{
		return this.create(this.stableStringHash("brotherhood-parent-tie-v1|" + _context, 32452843));
	}
};
