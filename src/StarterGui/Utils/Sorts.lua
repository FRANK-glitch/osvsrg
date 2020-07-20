return {
    Leaderboard = function(a, b)
        if a.rating == b.rating then
            return a.score > b.score
        end
        return a.rating > b.rating
    end
}