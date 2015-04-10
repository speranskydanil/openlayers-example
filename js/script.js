function create_image (id, path) {
  var map = new OpenLayers.Map({
    div: id,
    layers: [new OpenLayers.Layer.XYZ('image', path + '/${z}/${x}_${y}.jpg')],
    controls: [
      new OpenLayers.Control.Navigation(),
      new OpenLayers.Control.Zoom(),
    ],
    center: [0, 0],
    zoom: 2,
    numZoomLevels: 7
  });

  map.isValidZoomLevel = function (zl) {
    return zl >= 2 && zl < this.getNumZoomLevels();
  };
}

