# Synchrony SDK

This package is a ccall wrapper for the [AprilTags](https://april.eecs.umich.edu/software/apriltag.html) library tailored for Julia.

## Installation
This package is not yet registered with JuliaLang/METADATA.jl, but can be easily installed in Julia 0.6 with:
```julia
Pkg.clone("https://github.com/Affie/AprilTags.jl.git")
Pkg.build("AprilTags")
```

## Usage
### Examples
See examples and test folder for basic AprilTag usage examples.

### Initialization
Initialize a detector with the default (tag36h11) tag family.
```julia
# Create default detector
detector = AprilTagDetector()
```
Some tag detector parameters can be set at this time.
The default parameters are the recommended starting point.
```julia
AprilTags.setnThreads(detector, 4)
AprilTags.setquad_decimate(detector, 1.0)
AprilTags.setquad_sigma(detector,0.0)
AprilTags.setrefine_edges(detector,1)
AprilTags.setrefine_decode(detector,0)
AprilTags.setrefine_pose(detector,0)
```    
Increase the image decimation if faster processing is required; the
trade-off is a slight decrease in detection range. A factor of 1.0
means the full-size input image is used.

Some Gaussian blur (quad_sigma) may help with noisy input images.

### Detection
Process an input image and return a vector of detections.
The input image can be loaded with the `Images` package.
```julia
image = load("example_image.jpg")
tags = detector(image)
#do something with tags here
```

The caller is responsible for freeing the memmory by calling
```julia
freeDetector!(detector)
```

## Manual Outline
```@contents
Pages = [
    "index.md"
    "func_ref.md"
    "reference.md"
]
```
