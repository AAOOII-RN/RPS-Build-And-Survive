--[[
## name:     Gruvbox-Light-Hard
## author:   morhetz (https://github.com/morhetz/gruvbox)
## license:  MIT
## blurb:    Retro groove color scheme (light hard)
]]

local rgb = love.math.colorFromBytes
local FCC = {
	bg = { rgb(249, 245, 215) },
	bg1 = { rgb(235, 219, 178) },
	bg2 = { rgb(213, 196, 161) },
	fg = { rgb(60, 56, 54) },
	fg0 = { rgb(40, 40, 40) },
	red = { rgb(157, 0, 6) },
	green = { rgb(121, 116, 14) },
	yellow = { rgb(181, 118, 20) },
	blue = { rgb(7, 102, 120) },
	purple = { rgb(143, 63, 113) },
	aqua = { rgb(66, 123, 88) },
	orange = { rgb(175, 58, 3) },
	gray = { rgb(146, 131, 116) },
}

function fcv(fcc, a)
	local fcc2 = FCC[fcc]
	return { fcc2[1], fcc2[2], fcc2[3], a or 1 }
end

function fcvlerp(fcva, fcvb, t)
	local fcv1 = fcv(fcva)
	local fcv2 = fcv(fcvb)
	return {
		fcv1[1] + t * (fcv2[1] - fcv1[1]),
		fcv1[2] + t * (fcv2[2] - fcv1[2]),
		fcv1[3] + t * (fcv2[3] - fcv1[3]),
		fcv1[4] + t * (fcv2[4] - fcv1[4]),
	}
end

return FCC
