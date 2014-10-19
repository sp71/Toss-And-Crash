local FSM = {}
FSM.__index = FSM


FSM.new = function ( owner )
	local fsm = {}
	fsm.owner = owner
	fsm.currentState = nil
	setmetatable( fsm, FSM )
	return fsm
end

function FSM:changeState( newstate )

	if not newstate then return end

	if self.currentState then
		self.currentState:exit( self.owner )
	end

	self.currentState = newstate
	self.currentState:enter ( self.owner )

end


-- update() gets called every frame!
function FSM:update ( event )

	if self.currentState then
		self.currentState:execute ( self.owner )
	end

end


return FSM
