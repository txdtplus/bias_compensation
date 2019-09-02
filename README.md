# bias_compensation
This is a bias compensation program used for 3D reconstruction. The inputs are RPC file and some GCPs(Ground Control Points).
It makes RPC file accurate enough for subsequent processing.

RPC(Rational Polynomial Coefficient) is a parameter file, which indicates a map from object space to image space.
The basic idea of this program is least square adjustment. First, we choose some GCPs. Then we subtract computed locations from real
locations and we get error. Then we establish an error model and use least square method to solve this model. Finally, we compensate
the bias and generate a new RPC file.
