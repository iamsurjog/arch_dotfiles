local current_title = ""

sys.watch("media", function(state)
    local new_title = state.title
    local art_url = state.art or ""

    -- Clean the URL: if it starts with "file://", strip the first 7 characters
    if string.sub(art_url, 1, 7) == "file://" then
        art_url = string.sub(art_url, 8)
    end
    
    -- Send the clean path to the Pleamar scene
    text.album_art = art_url

    fact.media_playing = state.playing

    if new_title and new_title ~= current_title then
        current_title = new_title
        fact.target_width = 200 + (#current_title * 5)
        -- Change this:
        if state.playing then
            fact.song_updated = true
        end
    end

end)
