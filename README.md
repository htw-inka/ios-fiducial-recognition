iOSFiducialRecognition
======================

Fiducial recognition for iOS platform
-------------------------------------

__iOSFiducialRecognition__ brings __libfidtrack__[1] to the iOS platform. With this software it is possible to recognize unique markers, so called [fiducials][2], in images in a very small amount of time. The given source code provides a well-documented example of how to recognize fiducials from the iPad camera stream.

The software has been tested on iPads of the second and third generation but should also run with small modifications on an iPhone.

Performance
-----------

The current implementation achieves a stable recognition of fiducials in 0.15 to 0.3 seconds on an 3rd gen. iPad, which makes it possible to use in an argmented reality application.

Prerequisites
-------------

This software requires __XCode 4.x__ to compile and run.

Usage
-----

The XCode project file can be found under `src/iOSFiducialRecognition.xcodeproj`. It contains a fully functional example of fiducial recognition using the camera video stream.

License
-------

This software is released under BSD 3-clause license which is contained in the file `LICENSE`.

[1]: __libfidtrack__ is part of the ReacTIVision framework developed by Martin Kaltenbrunner and Ross Bencina at the Music Technology Group at the Universitat Pompeu Fabra in Barcelona, Spain. See http://reactivision.sourceforge.net/ for more information.
[2]: http://mtg.upf.edu/files/publications/376678-3rditeration2005-mkalten.pdf