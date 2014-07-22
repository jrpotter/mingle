function initialize(options) {
    return function() {

        // These are intentionally global objects
        zoom = document.getElementById('zoom');
        pano = document.getElementById('pano');
        pitch = document.getElementById('pitch');
        heading = document.getElementById('heading');

        // Begin centering around designated area
        var target = new google.maps.LatLng(options['latitude'], options['longitude']);
        var service = new google.maps.StreetViewService();

        // Begin call
        service.getPanoramaByLocation(target, 50, function(data, status) {

            if(status === google.maps.StreetViewStatus.OK) {

                var panorama = new google.maps.StreetViewPanorama(pano, {
                    position: data.location.latLng,
                    enableCloseButton: false,
                    addressControl: false,
                    linksControl: false,
                    panControl: false,
                    pov: {
                        heading: options['heading'],
                        pitch: options['pitch'],
                        zoom: options['zoom']
                    }
                });

                google.maps.event.addListener(panorama, 'pov_changed', function() {
                    zoom.value = panorama.getPov().zoom;
                    pitch.value = panorama.getPov().pitch;
                    heading.value = panorama.getPov().heading;
                });

                google.maps.event.trigger(panorama, 'pov_changed');
            }

            else if(status === google.maps.StreetViewStatus.ZERO_RESULTS) {

            }

            else if(status === google.maps.StreetViewStatus.UNKNOWN_ERROR) {

            }

        });
    };
}