raster2mesh <- function(ras, material, model_dir) {
  m <- terra::as.matrix(ras, wide=TRUE)
  m[is.na(m)] <- mean(m, na.rm = TRUE)
  if (missing(material)) {
    r_max <- max(m, na.rm = TRUE)
    r_min <- min(m, na.rm = TRUE)
    norm_m <- (m - r_min) / (r_max - r_min)
    r_m <- norm_m
    g_m <- norm_m
    b_m <- norm_m
    colors <- viridis::viridis(256)
    for (i in 1:nrow(norm_m)) {
      for (j in 1:ncol(norm_m)) {
        rgb_values <- col2rgb(colors[ceiling(norm_m[i,j] * 255)])
        r_m[i,j] <- rgb_values[1]
        g_m[i,j] <- rgb_values[2]
        b_m[i,j] <- rgb_values[3]
      }
    }
    arr <- array(c(r_m, g_m, b_m),
                 c(nrow(norm_m), ncol(norm_m), 3))
    # Rotate 90 degrees clockwise 2 times
    for (i in seq_len(2 %% 4)) {
      arr <- arr[rev(seq_len(dim(arr)[1])), , , drop = FALSE]  
      arr <- aperm(arr, c(2, 1, 3))                            
    }
    arr <- arr[, rev(seq_len(dim(arr)[2])), , drop = FALSE]
    png::writePNG(arr, paste0(model_dir, "/material.png"))
  } else {
    map <- terra::as.matrix(material, wide=TRUE)
  }
  m <- (m - min(m, na.rm = TRUE))
  m <- m/sd(m, na.rm = TRUE)
  
  map <- raster::stack(paste0(model_dir, "/material.png"))
  qm <- quadmesh::quadmesh(m, texture=map,
                           texture_filename = paste0(model_dir,
                                                     "/material.png"))
  suppressWarnings(
    mesh <- Morpho::quad2trimesh(qm, updateNormals = TRUE)
  )
  return(mesh)
}

write_MTL <- function(model_path){
  mtl_content <- paste(
    "newmtl material",
    "Ka 0.000000 0.000000 0.000000",
    "Kd 1.000000 1.000000 1.000000",
    "Ks 0.500000 0.500000 0.500000",
    "Ns 96.078431",
    "Ni 1.000000",
    "d 1.000000",
    "illum 2",
    "Ns 90.0000",
    "map_Kd material.png",
    sep = "\n"
  )
  writeLines(mtl_content, paste0(model_path, "/material.mtl"))
}

writeObj <- function(mesh, dir, outtype=) {
  vb <- t(mesh[["vb"]])
  vt <- t(mesh[["texcoords"]])
  vn <- t(mesh[["normals"]])
  it <- t(mesh[["it"]])
  vb <- vb[,-4]
  vn <- vn[,-4]
  vn[,3] <- -1 * vn[,3]
  vb <- round(vb, digits = 6)
  vt <- round(vt, digits = 6)
  vn <- round(vn, digits = 6)
  # compose f lines
  f_lines <- character(nrow(it))
  for (i in seq_len(nrow(it))) {
    indices <- rev(it[i, 1:3])
    f_lines[i] <- paste(
      "f",
      paste(
        indices,
        indices,
        indices,
        sep = "/",
        collapse = " "
      )
    )
  }
  vb <- cbind(vb, rep("v",length(vb[,1])))
  vt <- cbind(vt, rep("vt",length(vt[,1])))
  vn <- cbind(vn, rep("vn",length(vn[,1])))
  colnames(vb)[4] <- "v"
  colnames(vt)[3] <- "v"
  colnames(vn) <- c("x","y","z","v")
  
  vb_line <- with(as.data.frame(vb), paste(v, x, y, z))
  vt_line <- with(as.data.frame(vt), paste(v, x, y))
  vn_line <- with(as.data.frame(vn), paste(v, x, y, z))
  obj_path1 <- paste0(dir, "/model.obj")
  obj_path2 <- paste0(dir, "/points.obj")
  obj_textureOn <- c("mtllib material.mtl",
                     vb_line, vt_line, vn_line,
                     "usemtl material",
                     f_lines)
  obj_textureOFF <- c(vb_line, vn_line)
  writeLines(obj_textureOn, obj_path1)
  writeLines(obj_textureOFF, obj_path2)
}


model_dir <- '/model2'
las <- dsmSearch::get_lidar(bbox = c(-83.731838,42.288739,-83.727601,42.291691), epsg = 2253)
ras <- lidR::rasterize_terrain(las, 10, lidR::tin())

mesh <- raster2mesh(ras=ras, model_dir=model_dir)
writeObj(mesh, dir = model_dir)
write_MTL(model_dir)





