function love.load()
	highscore = h
end
function highscoretable()
	for i, score, name in highscore() do
    love.graphics.print(name, 400, i * 40)
    love.graphics.print(score, 500, i * 40)
	end
end
function highscoresave() highscore.save() end

function highscoreadd() highscore.add( name, score) end

function h.set(filename, places, name, score)
	h.filename = filename
	h.places = places
	if not h.load() then
		h.scores = {}
		for i = 1, places do
			h.scores[i] = {score, name}
		end
	end
end

function h.load()
	local file = love.filesystem.newFile(h.filename)
	if not love.filesystem.exists(h.filename) or not file:open("r") then return end
	h.scores = {}
	for line in file:lines() do
		local i = line:find('\t', 1, true)
		h.scores[#h.scores+1] = {tonumber(line:sub(1, i-1)), line:sub(i+1)}
	end
	return file:close()
end

local function sortScore(a, b)
	return a[1] > b[1]
end
function h.add(name, score)
print(#h.scores)
	h.scores[#h.scores+1] = {score, name}
	table.sort(h.scores, sortScore)
end

function h.save()
	local file = love.filesystem.newFile(h.filename)
	if not file:open("w") then return end
	for i = 1, #h.scores do
		item = h.scores[i]
		file:write(item[1] .. "\t" .. item[2] .. "\n")
	end
	return file:close()
end

setmetatable(h, {__call = function(self)
	local i = 0
	return function()
		i = i + 1
		if i <= h.places and h.scores[i] then
			return i, unpack(h.scores[i])
		end
	end
end})

highscore = h

return h
