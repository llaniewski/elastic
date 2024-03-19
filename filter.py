input0 = inputs[0]
if input0.IsA("vtkImageData"):
    ext = input0.GetExtent()
    U = input0.CellData["U"]
    shp = [ext[5]-ext[4],ext[3]-ext[2],ext[1]-ext[0],3]
    nU = U.reshape(shp)
    nU = concatenate([nU,nU[[0],:,:,:]],axis=0)
    nU = concatenate([nU,nU[:,[0],:,:]],axis=1)
    nU = concatenate([nU,nU[:,:,[0],:]],axis=2)
    nU = nU.reshape([-1,3])
    output.PointData.append(nU, "nU")
