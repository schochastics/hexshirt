library(tidyverse)
logos <- read_csv("hex.csv") |>
    dplyr::filter(!is.na(logo))


for (i in 1:nrow(logos)) {
    cat(i, "\r")
    tryCatch(download.file(logos$logo[i], paste0("img/", logos$package[i], ".png"), quiet = TRUE), error = function(e) cat("\n fail\n"))
    Sys.sleep(runif(1, 2, 5))
    if (runif(1) > 0.88) {
        Sys.sleep(runif(1, 10, 60))
    }
}

# write hexagonal tileset to use with https://www.mapeditor.org/
header <- '<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.2" tiledversion="1.4.3" name="Hexagonal Tileset" tilewidth="100" tileheight="100" tilecount="NUMBER_OF_IMAGES" columns="0">
  <grid orientation="hexagonal" width="100" height="100"/>'

write(header, file = "hex_tileset.tsx", append = FALSE)
fs <- paste0(list.files("resized_img100_picked", full.names = TRUE))
for (i in 1:length(fs)) {
    paste0('
    <tile id="', i - 1, '">
    <image width="100" height="100" source="', fs[i], '"/>
  </tile>') |> write("hex_tileset.tsx", append = TRUE)
}
write("</tileset>", "hex_tileset.tsx", append = TRUE)

# decrease size of logos
# for img in img/*.png; do convert "$img" -verbose -strip -resize 100x116 PNG32:"resized_img100/$(basename "$img")"; done

A <- jsonlite::fromJSON("hexmap.tmj")
B <- matrix(sample(all), 47, 47)
A$layers$data <- c(B)
jsonlite::write_json(A, "hexmap2.tmj", simplifyVector = FALSE)

write(paste0(apply(B, 1, paste0, collapse = ","), collapse = "\n"), "tmp")
