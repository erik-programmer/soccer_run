-- love.graphics.getWidth  - returns width of the whole window
-- love.graphics.getHeight - returns hight of the whole window
-- love.graphics.newImage(some string) - loads image from file with string name
-- love.graphics.draw(what, x, y) - draws an image with position x and y
-- love.graphics.print(text, x, y) - draws a text on position x and y
-- love.keyboard.isDown("left") - returns if left arrow was pressed
package.path = package.path .. ";../table_extensions/table_extensions.lua"
require("table_extensions")

local teams = {
    { name = "Barca",  points = 0 },
    { name = "Real",   points = 0 },
    { name = "Bayern", points = 0 }
}

local players = {
    { name = "Yamal",       points = {}, team = teams[1] },
    { name = "Neuer",       points = {}, team = teams[3] },
    { name = "Mbappe",      points = {}, team = teams[2] },
    { name = "Bellingham",  points = {}, team = teams[2] },
    { name = "Kimmich",     points = {}, team = teams[3] },
    { name = "Musiala",     points = {}, team = teams[3] },
    { name = "Raphinha",    points = {}, team = teams[1] },
    { name = "Rodrygo",     points = {}, team = teams[2] },
    { name = "Lewandowski", points = {}, team = teams[1] }
}

local draw_image = nil
local lost_image = nil
local won_image = nil
local happy_image = nil
local neutral_image = nil
local sad_image = nil
local third_place_image = nil
local function round()
    if #teams == 2 and #players[1].points == 10 then
        return
    end
    if #players[1].points > 9 then
        for index, player in ipairs(players) do
            player.points = {}
        end
        players = table.filter(players, function(e)
            return e.team ~= teams[3]
        end)
        third_place_image = teams[3].photo
        table.remove(teams, 3)
        for index, team in ipairs(teams) do
            team.points = 0
        end
    end
    for index, player in ipairs(players) do
        local random = math.random(0, 2)
        if random == 0 then
            table.insert(player.points, 0)
        end
        if random == 1 then
            table.insert(player.points, 1)
            player.team.points = player.team.points + 1
        end
        if random == 2 then
            table.insert(player.points, 3)
            player.team.points = player.team.points + 3
        end
    end
    table.sort(players, function(e1, e2)
        return table.sum(e1.points) > table.sum(e2.points)
    end)
    table.sort(teams, function(e1, e2)
        return e1.points > e2.points
    end)
end

function love.load()
    math.randomseed(os.time())
    for index, player in ipairs(players) do
        player.photo = love.graphics.newImage(player.name .. ".png")
    end
    round()
    draw_image = love.graphics.newImage("Draw.png")
    won_image = love.graphics.newImage("Won.png")
    lost_image = love.graphics.newImage("Lost.png")

    happy_image = love.graphics.newImage("Happy.png")
    neutral_image = love.graphics.newImage("Neutral.png")
    sad_image = love.graphics.newImage("Sad.png")
    for index, team in ipairs(teams) do
        team.photo = love.graphics.newImage(team.name .. ".png")
    end
end

local enter_down = false
function love.update(dt)
    if love.keyboard.isDown("return") then
        if enter_down == false then
            round()
        end
        enter_down = true
    else
        enter_down = false
    end
end

function love.draw()
    if #teams == 2 and #players[1].points == 10 then
        love.graphics.draw(teams[1].photo, 70, 100, 0, 0.6, 0.6)
        love.graphics.draw(teams[2].photo, 320, 100, 0, 0.6, 0.6)
        love.graphics.draw(third_place_image, 600, 100, 0, 0.6, 0.6)
        love.graphics.draw(happy_image, 70, 250, 0, 0.17, 0.17)
        love.graphics.draw(neutral_image, 320, 250, 0, 0.1, 0.1)
        love.graphics.draw(sad_image, 600, 250, 0, 0.13, 0.13)
    else
        for index, player in ipairs(players) do
            love.graphics.draw(player.photo, 10, (index - 1) * 60 + 10, 0, 0.17, 0.17)
            for index2, point in ipairs(player.points) do
                if point == 0 then
                    love.graphics.draw(lost_image, (index2 - 1) * 60 + 70, (index - 1) * 60 + 10, 0, 0.07, 0.07)
                end
                if point == 1 then
                    love.graphics.draw(draw_image, (index2 - 1) * 60 + 70, (index - 1) * 60 + 10, 0, 0.07, 0.07)
                end
                if point == 3 then
                    love.graphics.draw(won_image, (index2 - 1) * 60 + 70, (index - 1) * 60 + 10, 0, 0.07, 0.07)
                end
            end
            love.graphics.print(table.sum(player.points), #player.points * 60 + 70, (index - 1) * 60 + 10)
        end
        love.graphics.draw(teams[1].photo, 70, 550, 0, 0.3, 0.3)
        love.graphics.draw(teams[2].photo, 320, 550, 0, 0.3, 0.3)
        if #teams == 3 then
            love.graphics.draw(teams[3].photo, 620, 550, 0, 0.3, 0.3)
        end
        love.graphics.print(teams[1].points, 120, 550)
        love.graphics.print(teams[2].points, 370, 550)
        if #teams == 3 then
            love.graphics.print(teams[3].points, 670, 550)
        end
    end
end
