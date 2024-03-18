
dsel = expand.grid(x=1:2,y=1:2,z=1:2)
xyz = c("x","y","z")
tab = expand.grid(
    i=seq_len(nrow(dsel)),
    d=xyz,
    stringsAsFactors = FALSE)
tab$n=letters[tab$i]
tab$dx = dsel$x[tab$i] - 1
tab$dy = dsel$y[tab$i] - 1
tab$dz = dsel$z[tab$i] - 1
tab$beta = paste0(tab$n,tab$d)
tab$u = paste0("u",tab$d)
tab$dbeta = paste0("d",tab$beta)

AddDensity(unique(tab$u),group="u")
AddDensity(tab$beta,dx=-tab$dx,dy=-tab$dy,dz=-tab$dz,field=tab$u,group="beta")
AddDensity(tab$dbeta,dx=tab$dx,dy=tab$dy,dz=tab$dz,group="dbeta")

AddStage("CalcU",load=DensityAll$group %in% c("dbeta","u"),save=Fields$group %in% "u")
AddStage("CalcD",load=DensityAll$group %in% "beta",save=Fields$group %in% "dbeta")
AddStage("InitU",save=Fields$group %in% "u")

AddAction("Init", c("InitU","CalcD"))
AddAction("Iteration", c("CalcU","CalcD"))

# 	Outputs:
AddQuantity(name="U",vector=TRUE)
AddQuantity(name="Dens")

#	Inputs: Flow Properties
AddSetting(name="Density", zonal=TRUE)
AddSetting(name="YoungModulus", zonal=TRUE)
AddSetting(name="PoissonRatio", zonal=TRUE)
AddSetting(name="DisplacementX", zonal=TRUE)
AddSetting(name="DisplacementY", zonal=TRUE)
AddSetting(name="DisplacementZ", zonal=TRUE)
AddSetting(name="Relaxation")

#	Boundary things:
AddNodeType(name="Dirichlet", group="BOUNDARY")
