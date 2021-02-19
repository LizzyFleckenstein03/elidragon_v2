local random = {
	choices = {},
	probabilities = {},
	csum = {},
	sum = 0
}

random.__index = random

function random:new(o)
    o = o or {}
    setmetatable(o, self)
    o.choices = {}
    o.probabilities = {}
    o.csum = {}
    o.sum = 0
    return o
end

function random:calc_csum()
	self.sum = 0
    for i, choice in ipairs(self.choices) do
        self.sum = self.sum + self.probabilities[choice]
        self.csum[choice] = self.sum
    end
end

function random:choose()
    local r = math.random() + math.random(0, self.sum - 1)
    for i, choice in pairs(self.choices) do
        if r < self.csum[choice] then
            return choice
        end
    end
end

function random:add_choice(choice, probability)
    table.insert(self.choices, choice)
    self.probabilities[choice] = probability
end 

elidragon.random = random
